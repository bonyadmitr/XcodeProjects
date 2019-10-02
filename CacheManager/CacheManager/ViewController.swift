//
//  ViewController.swift
//  CacheManager
//
//  Created by Bondar Yaroslav on 10/2/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

// MARK: - MemoryStorage

/// Represents a storage which stores a certain type of value in memory. It provides fast access,
/// but limited storing size. The stored value type needs to conform to `CacheCostCalculable`,
/// and its `cacheCost` will be used to determine the cost of size for the cache item.
///
/// You can config a `MemoryStorage.Backend` in its initializer by passing a `MemoryStorage.Config` value.
/// or modifying the `config` property after it being created. The backend of `MemoryStorage` has
/// upper limitation on cost size in memory and item count. All items in the storage has an expiration
/// date. When retrieved, if the target item is already expired, it will be recognized as it does not
/// exist in the storage. The `MemoryStorage` also contains a scheduled self clean task, to evict expired
/// items from memory.
public class Backend<T: CacheCostCalculable> {
    let storage = NSCache<NSString, StorageObject<T>>()

    // Keys trackes the objects once inside the storage. For object removing triggered by user, the corresponding
    // key would be also removed. However, for the object removing triggered by cache rule/policy of system, the
    // key will be remained there until next `removeExpired` happens.
    //
    // Breaking the strict tracking could save additional locking behaviors.
    // See https://github.com/onevcat/Kingfisher/issues/1233
    var keys = Set<String>()

    private var cleanTimer: Timer? = nil
    private let lock = NSLock()

    /// The config used in this storage. It is a value you can set and
    /// use to config the storage in air.
    public var config: Config {
        didSet {
            storage.totalCostLimit = config.totalCostLimit
            storage.countLimit = config.countLimit
        }
    }

    /// Creates a `MemoryStorage` with a given `config`.
    ///
    /// - Parameter config: The config used to create the storage. It determines the max size limitation,
    ///                     default expiration setting and more.
    public init(config: Config) {
        self.config = config
        storage.totalCostLimit = config.totalCostLimit
        storage.countLimit = config.countLimit

        cleanTimer = .scheduledTimer(withTimeInterval: config.cleanInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.removeExpired()
        }
    }

    func removeExpired() {
        lock.lock()
        defer { lock.unlock() }
        for key in keys {
            let nsKey = key as NSString
            guard let object = storage.object(forKey: nsKey) else {
                // This could happen if the object is moved by cache `totalCostLimit` or `countLimit` rule.
                // We didn't remove the key yet until now, since we do not want to introduce additonal lock.
                // See https://github.com/onevcat/Kingfisher/issues/1233
                keys.remove(key)
                continue
            }
            if object.estimatedExpiration.isPast {
                storage.removeObject(forKey: nsKey)
                keys.remove(key)
            }
        }
    }

    // Storing in memory will not throw. It is just for meeting protocol requirement and
    // forwarding to no throwing method.
    func store(
        value: T,
        forKey key: String,
        expiration: StorageExpiration? = nil) throws
    {
        storeNoThrow(value: value, forKey: key, expiration: expiration)
    }

    // The no throw version for storing value in cache. Kingfisher knows the detail so it
    // could use this version to make syntax simpler internally.
    func storeNoThrow(
        value: T,
        forKey key: String,
        expiration: StorageExpiration? = nil)
    {
        lock.lock()
        defer { lock.unlock() }
        let expiration = expiration ?? config.expiration
        // The expiration indicates that already expired, no need to store.
        guard !expiration.isExpired else { return }
        
        let object = StorageObject(value, key: key, expiration: expiration)
        storage.setObject(object, forKey: key as NSString, cost: value.cacheCost)
        keys.insert(key)
    }
    
    /// Use this when you actually access the memory cached item.
    /// By default, this will extend the expired data for the accessed item.
    ///
    /// - Parameters:
    ///   - key: Cache Key
    ///   - extendingExpiration: expiration value to extend item expiration time:
    ///     * .none: The item expires after the original time, without extending after access.
    ///     * .cacheTime: The item expiration extends by the original cache time after each access.
    ///     * .expirationTime: The item expiration extends by the provided time after each access.
    /// - Returns: cached object or nil
    func value(forKey key: String, extendingExpiration: ExpirationExtending = .cacheTime) -> T? {
        guard let object = storage.object(forKey: key as NSString) else {
            return nil
        }
        if object.expired {
            return nil
        }
        object.extendExpiration(extendingExpiration)
        return object.value
    }

    func isCached(forKey key: String) -> Bool {
        guard let _ = value(forKey: key, extendingExpiration: .none) else {
            return false
        }
        return true
    }

    func remove(forKey key: String) throws {
        lock.lock()
        defer { lock.unlock() }
        storage.removeObject(forKey: key as NSString)
        keys.remove(key)
    }

    func removeAll() throws {
        lock.lock()
        defer { lock.unlock() }
        storage.removeAllObjects()
        keys.removeAll()
    }
}

/// Represents the config used in a `MemoryStorage`.
public struct Config {

    /// Total cost limit of the storage in bytes.
    public var totalCostLimit: Int

    /// The item count limit of the memory storage.
    public var countLimit: Int = .max

    /// The `StorageExpiration` used in this memory storage. Default is `.seconds(300)`,
    /// means that the memory cache would expire in 5 minutes.
    public var expiration: StorageExpiration = .seconds(300)

    /// The time interval between the storage do clean work for swiping expired items.
    public let cleanInterval: TimeInterval

    /// Creates a config from a given `totalCostLimit` value.
    ///
    /// - Parameters:
    ///   - totalCostLimit: Total cost limit of the storage in bytes.
    ///   - cleanInterval: The time interval between the storage do clean work for swiping expired items.
    ///                    Default is 120, means the auto eviction happens once per two minutes.
    ///
    /// - Note:
    /// Other members of `MemoryStorage.Config` will use their default values when created.
    public init(totalCostLimit: Int, cleanInterval: TimeInterval = 120) {
        self.totalCostLimit = totalCostLimit
        self.cleanInterval = cleanInterval
    }
}

/// Represents types which cost in memory can be calculated.
public protocol CacheCostCalculable {
    var cacheCost: Int { get }
}

class StorageObject<T> {
    let value: T
    let expiration: StorageExpiration
    let key: String
    
    private(set) var estimatedExpiration: Date
    
    init(_ value: T, key: String, expiration: StorageExpiration) {
        self.value = value
        self.key = key
        self.expiration = expiration
        
        self.estimatedExpiration = expiration.estimatedExpirationSinceNow
    }

    func extendExpiration(_ extendingExpiration: ExpirationExtending = .cacheTime) {
        switch extendingExpiration {
        case .none:
            return
        case .cacheTime:
            self.estimatedExpiration = expiration.estimatedExpirationSinceNow
        case .expirationTime(let expirationTime):
            self.estimatedExpiration = expirationTime.estimatedExpirationSinceNow
        }
    }
    
    var expired: Bool {
        return estimatedExpiration.isPast
    }
}

public enum StorageExpiration {
    /// The item never expires.
    case never
    /// The item expires after a time duration of given seconds from now.
    case seconds(TimeInterval)
    /// The item expires after a time duration of given days from now.
    case days(Int)
    /// The item expires after a given date.
    case date(Date)
    /// Indicates the item is already expired. Use this to skip cache.
    case expired

    func estimatedExpirationSince(_ date: Date) -> Date {
        switch self {
        case .never: return .distantFuture
        case .seconds(let seconds):
            return date.addingTimeInterval(seconds)
        case .days(let days):
            let duration = TimeInterval(TimeConstants.secondsInOneDay * days)
            return date.addingTimeInterval(duration)
        case .date(let ref):
            return ref
        case .expired:
            return .distantPast
        }
    }
    
    var estimatedExpirationSinceNow: Date {
        return estimatedExpirationSince(Date())
    }
    
    var isExpired: Bool {
        return timeInterval <= 0
    }

    var timeInterval: TimeInterval {
        switch self {
        case .never: return .infinity
        case .seconds(let seconds): return seconds
        case .days(let days): return TimeInterval(TimeConstants.secondsInOneDay * days)
        case .date(let ref): return ref.timeIntervalSinceNow
        case .expired: return -(.infinity)
        }
    }
}


/// Represents the expiration extending strategy used in storage to after access.
///
/// - none: The item expires after the original time, without extending after access.
/// - cacheTime: The item expiration extends by the original cache time after each access.
/// - expirationTime: The item expiration extends by the provided time after each access.
public enum ExpirationExtending {
    /// The item expires after the original time, without extending after access.
    case none
    /// The item expiration extends by the original cache time after each access.
    case cacheTime
    /// The item expiration extends by the provided time after each access.
    case expirationTime(_ expiration: StorageExpiration)
}


/// Constants for some time intervals
struct TimeConstants {
    static let secondsInOneMinute = 60
    static let minutesInOneHour = 60
    static let hoursInOneDay = 24
    static let secondsInOneDay = secondsInOneMinute * minutesInOneHour * hoursInOneDay
}

extension Date {
    var isPast: Bool {
        return isPast(referenceDate: Date())
    }

    var isFuture: Bool {
        return !isPast
    }

    func isPast(referenceDate: Date) -> Bool {
        return timeIntervalSince(referenceDate) <= 0
    }

    func isFuture(referenceDate: Date) -> Bool {
        return !isPast(referenceDate: referenceDate)
    }

    // `Date` in memory is a wrap for `TimeInterval`. But in file attribute it can only accept `Int` number.
    // By default the system will `round` it. But it is not friendly for testing purpose.
    // So we always `ceil` the value when used for file attributes.
    var fileAttributeDate: Date {
        return Date(timeIntervalSince1970: ceil(timeIntervalSince1970))
    }
}


/// Represents a set of conception related to storage which stores a certain type of value in disk.
/// This is a namespace for the disk storage types. A `Backend` with a certain `Config` will be used to describe the
/// storage. See these composed types for more information.
public enum DiskStorage {

    /// Represents a storage back-end for the `DiskStorage`. The value is serialized to data
    /// and stored as file in the file system under a specified location.
    ///
    /// You can config a `DiskStorage.Backend` in its initializer by passing a `DiskStorage.Config` value.
    /// or modifying the `config` property after it being created. `DiskStorage` will use file's attributes to keep
    /// track of a file for its expiration or size limitation.
    public class Backend<T: DataTransformable> {
        /// The config used for this disk storage.
        public var config: Config

        // The final storage URL on disk, with `name` and `cachePathBlock` considered.
        public let directoryURL: URL

        let metaChangingQueue: DispatchQueue

        /// Creates a disk storage with the given `DiskStorage.Config`.
        ///
        /// - Parameter config: The config used for this disk storage.
        /// - Throws: An error if the folder for storage cannot be got or created.
        public init(config: Config) throws {

            self.config = config

            let url: URL
            if let directory = config.directory {
                url = directory
            } else {
                url = try config.fileManager.url(
                    for: .cachesDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true)
            }

            let cacheName = "com.onevcat.Kingfisher.ImageCache.\(config.name)"
            directoryURL = config.cachePathBlock(url, cacheName)

            metaChangingQueue = DispatchQueue(label: cacheName)

            try prepareDirectory()
        }

        // Creates the storage folder.
        func prepareDirectory() throws {
            let fileManager = config.fileManager
            let path = directoryURL.path

            guard !fileManager.fileExists(atPath: path) else { return }

            do {
                try fileManager.createDirectory(
                    atPath: path,
                    withIntermediateDirectories: true,
                    attributes: nil)
            } catch {
                throw someError
                //throw KingfisherError.cacheError(reason: .cannotCreateDirectory(path: path, error: error))
            }
        }

        func store(
            value: T,
            forKey key: String,
            expiration: StorageExpiration? = nil) throws
        {
            let expiration = expiration ?? config.expiration
            // The expiration indicates that already expired, no need to store.
            guard !expiration.isExpired else { return }
            
            let data: Data
            do {
                data = try value.toData()
            } catch {
                throw someError
                //throw KingfisherError.cacheError(reason: .cannotConvertToData(object: value, error: error))
            }

            let fileURL = cacheFileURL(forKey: key)

            let now = Date()
            let attributes: [FileAttributeKey : Any] = [
                // The last access date.
                .creationDate: now.fileAttributeDate,
                // The estimated expiration date.
                .modificationDate: expiration.estimatedExpirationSinceNow.fileAttributeDate
            ]
            config.fileManager.createFile(atPath: fileURL.path, contents: data, attributes: attributes)
        }

        func value(forKey key: String, extendingExpiration: ExpirationExtending = .cacheTime) throws -> T? {
            return try value(forKey: key, referenceDate: Date(), actuallyLoad: true, extendingExpiration: extendingExpiration)
        }

        func value(
            forKey key: String,
            referenceDate: Date,
            actuallyLoad: Bool,
            extendingExpiration: ExpirationExtending) throws -> T?
        {
            let fileManager = config.fileManager
            let fileURL = cacheFileURL(forKey: key)
            let filePath = fileURL.path
            guard fileManager.fileExists(atPath: filePath) else {
                return nil
            }

            let meta: FileMeta
            do {
                let resourceKeys: Set<URLResourceKey> = [.contentModificationDateKey, .creationDateKey]
                meta = try FileMeta(fileURL: fileURL, resourceKeys: resourceKeys)
            } catch {
                throw someError
                //throw KingfisherError.cacheError(reason: .invalidURLResource(error: error, key: key, url: fileURL))
            }

            if meta.expired(referenceDate: referenceDate) {
                return nil
            }
            if !actuallyLoad { return T.empty }

            do {
                let data = try Data(contentsOf: fileURL)
                let obj = try T.fromData(data)
                metaChangingQueue.async { meta.extendExpiration(with: fileManager, extendingExpiration: extendingExpiration) }
                return obj
            } catch {
                throw someError
                //throw KingfisherError.cacheError(reason: .cannotLoadDataFromDisk(url: fileURL, error: error))
            }
        }

        func isCached(forKey key: String) -> Bool {
            return isCached(forKey: key, referenceDate: Date())
        }

        func isCached(forKey key: String, referenceDate: Date) -> Bool {
            do {
                guard let _ = try value(forKey: key, referenceDate: referenceDate, actuallyLoad: false, extendingExpiration: .none) else {
                    return false
                }
                return true
            } catch {
                return false
            }
        }

        func remove(forKey key: String) throws {
            let fileURL = cacheFileURL(forKey: key)
            try removeFile(at: fileURL)
        }

        func removeFile(at url: URL) throws {
            try config.fileManager.removeItem(at: url)
        }

        func removeAll() throws {
            try removeAll(skipCreatingDirectory: false)
        }

        func removeAll(skipCreatingDirectory: Bool) throws {
            try config.fileManager.removeItem(at: directoryURL)
            if !skipCreatingDirectory {
                try prepareDirectory()
            }
        }

        /// The URL of the cached file with a given computed `key`.
        ///
        /// - Note:
        /// This method does not guarantee there is an image already cached in the returned URL. It just gives your
        /// the URL that the image should be if it exists in disk storage, with the give key.
        ///
        /// - Parameter key: The final computed key used when caching the image. Please note that usually this is not
        /// the `cacheKey` of an image `Source`. It is the computed key with processor identifier considered.
        public func cacheFileURL(forKey key: String) -> URL {
            let fileName = cacheFileName(forKey: key)
            return directoryURL.appendingPathComponent(fileName)
        }

        func cacheFileName(forKey key: String) -> String {
            if config.usesHashedFileName {
                let hashedKey = key.md5
                if let ext = config.pathExtension {
                    return "\(hashedKey).\(ext)"
                }
                return hashedKey
            } else {
                if let ext = config.pathExtension {
                    return "\(key).\(ext)"
                }
                return key
            }
        }

        func allFileURLs(for propertyKeys: [URLResourceKey]) throws -> [URL] {
            let fileManager = config.fileManager

            guard let directoryEnumerator = fileManager.enumerator(
                at: directoryURL, includingPropertiesForKeys: propertyKeys, options: .skipsHiddenFiles) else
            {
                throw someError
                //throw KingfisherError.cacheError(reason: .fileEnumeratorCreationFailed(url: directoryURL))
            }

            guard let urls = directoryEnumerator.allObjects as? [URL] else {
                throw someError
                //throw KingfisherError.cacheError(reason: .invalidFileEnumeratorContent(url: directoryURL))
            }
            return urls
        }

        func removeExpiredValues(referenceDate: Date = Date()) throws -> [URL] {
            let propertyKeys: [URLResourceKey] = [
                .isDirectoryKey,
                .contentModificationDateKey
            ]

            let urls = try allFileURLs(for: propertyKeys)
            let keys = Set(propertyKeys)
            let expiredFiles = urls.filter { fileURL in
                do {
                    let meta = try FileMeta(fileURL: fileURL, resourceKeys: keys)
                    if meta.isDirectory {
                        return false
                    }
                    return meta.expired(referenceDate: referenceDate)
                } catch {
                    return true
                }
            }
            try expiredFiles.forEach { url in
                try removeFile(at: url)
            }
            return expiredFiles
        }

        func removeSizeExceededValues() throws -> [URL] {

            if config.sizeLimit == 0 { return [] } // Back compatible. 0 means no limit.

            var size = try totalSize()
            if size < config.sizeLimit { return [] }

            let propertyKeys: [URLResourceKey] = [
                .isDirectoryKey,
                .creationDateKey,
                .fileSizeKey
            ]
            let keys = Set(propertyKeys)

            let urls = try allFileURLs(for: propertyKeys)
            var pendings: [FileMeta] = urls.compactMap { fileURL in
                guard let meta = try? FileMeta(fileURL: fileURL, resourceKeys: keys) else {
                    return nil
                }
                return meta
            }
            // Sort by last access date. Most recent file first.
            pendings.sort(by: FileMeta.lastAccessDate)

            var removed: [URL] = []
            let target = config.sizeLimit / 2
            while size > target, let meta = pendings.popLast() {
                size -= UInt(meta.fileSize)
                try removeFile(at: meta.url)
                removed.append(meta.url)
            }
            return removed
        }

        /// Get the total file size of the folder in bytes.
        func totalSize() throws -> UInt {
            let propertyKeys: [URLResourceKey] = [.fileSizeKey]
            let urls = try allFileURLs(for: propertyKeys)
            let keys = Set(propertyKeys)
            let totalSize: UInt = urls.reduce(0) { size, fileURL in
                do {
                    let meta = try FileMeta(fileURL: fileURL, resourceKeys: keys)
                    return size + UInt(meta.fileSize)
                } catch {
                    return size
                }
            }
            return totalSize
        }
    }
}

extension DiskStorage {
    /// Represents the config used in a `DiskStorage`.
    public struct Config {

        /// The file size limit on disk of the storage in bytes. 0 means no limit.
        public var sizeLimit: UInt

        /// The `StorageExpiration` used in this disk storage. Default is `.days(7)`,
        /// means that the disk cache would expire in one week.
        public var expiration: StorageExpiration = .days(7)

        /// The preferred extension of cache item. It will be appended to the file name as its extension.
        /// Default is `nil`, means that the cache file does not contain a file extension.
        public var pathExtension: String? = nil

        /// Default is `true`, means that the cache file name will be hashed before storing.
        public var usesHashedFileName = true

        let name: String
        let fileManager: FileManager
        let directory: URL?

        var cachePathBlock: ((_ directory: URL, _ cacheName: String) -> URL)! = {
            (directory, cacheName) in
            return directory.appendingPathComponent(cacheName, isDirectory: true)
        }

        /// Creates a config value based on given parameters.
        ///
        /// - Parameters:
        ///   - name: The name of cache. It is used as a part of storage folder. It is used to identify the disk
        ///           storage. Two storages with the same `name` would share the same folder in disk, and it should
        ///           be prevented.
        ///   - sizeLimit: The size limit in bytes for all existing files in the disk storage.
        ///   - fileManager: The `FileManager` used to manipulate files on disk. Default is `FileManager.default`.
        ///   - directory: The URL where the disk storage should live. The storage will use this as the root folder,
        ///                and append a path which is constructed by input `name`. Default is `nil`, indicates that
        ///                the cache directory under user domain mask will be used.
        public init(
            name: String,
            sizeLimit: UInt,
            fileManager: FileManager = .default,
            directory: URL? = nil)
        {
            self.name = name
            self.fileManager = fileManager
            self.directory = directory
            self.sizeLimit = sizeLimit
        }
    }
}

extension DiskStorage {
    struct FileMeta {
    
        let url: URL
        
        let lastAccessDate: Date?
        let estimatedExpirationDate: Date?
        let isDirectory: Bool
        let fileSize: Int
        
        static func lastAccessDate(lhs: FileMeta, rhs: FileMeta) -> Bool {
            return lhs.lastAccessDate ?? .distantPast > rhs.lastAccessDate ?? .distantPast
        }
        
        init(fileURL: URL, resourceKeys: Set<URLResourceKey>) throws {
            let meta = try fileURL.resourceValues(forKeys: resourceKeys)
            self.init(
                fileURL: fileURL,
                lastAccessDate: meta.creationDate,
                estimatedExpirationDate: meta.contentModificationDate,
                isDirectory: meta.isDirectory ?? false,
                fileSize: meta.fileSize ?? 0)
        }
        
        init(
            fileURL: URL,
            lastAccessDate: Date?,
            estimatedExpirationDate: Date?,
            isDirectory: Bool,
            fileSize: Int)
        {
            self.url = fileURL
            self.lastAccessDate = lastAccessDate
            self.estimatedExpirationDate = estimatedExpirationDate
            self.isDirectory = isDirectory
            self.fileSize = fileSize
        }

        func expired(referenceDate: Date) -> Bool {
            return estimatedExpirationDate?.isPast(referenceDate: referenceDate) ?? true
        }
        
        func extendExpiration(with fileManager: FileManager, extendingExpiration: ExpirationExtending) {
            guard let lastAccessDate = lastAccessDate,
                  let lastEstimatedExpiration = estimatedExpirationDate else
            {
                return
            }

            let attributes: [FileAttributeKey : Any]

            switch extendingExpiration {
            case .none:
                // not extending expiration time here
                return
            case .cacheTime:
                let originalExpiration: StorageExpiration =
                    .seconds(lastEstimatedExpiration.timeIntervalSince(lastAccessDate))
                attributes = [
                    .creationDate: Date().fileAttributeDate,
                    .modificationDate: originalExpiration.estimatedExpirationSinceNow.fileAttributeDate
                ]
            case .expirationTime(let expirationTime):
                attributes = [
                    .creationDate: Date().fileAttributeDate,
                    .modificationDate: expirationTime.estimatedExpirationSinceNow.fileAttributeDate
                ]
            }

            try? fileManager.setAttributes(attributes, ofItemAtPath: url.path)
        }
    }
}

/// Represents types which can be converted to and from data.
public protocol DataTransformable {
    func toData() throws -> Data
    static func fromData(_ data: Data) throws -> Self
    static var empty: Self { get }
}

extension String {
    var md5: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }

        #if swift(>=5.0)
        let message = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return [UInt8](bytes)
        }
        #else
        let message = data.withUnsafeBytes { bytes in
            return [UInt8](UnsafeBufferPointer(start: bytes, count: data.count))
        }
        #endif

        let MD5Calculator = MD5(message)
        let MD5Data = MD5Calculator.calculate()

        var MD5String = String()
        for c in MD5Data {
            MD5String += String(format: "%02x", c)
        }
        return MD5String
    }
}

class MD5 {

    static let size = 16 // 128 / 8
    let message: [UInt8]

    init (_ message: [UInt8]) {
        self.message = message
    }

    // specifies the per-round shift amounts
    private let shifts: [UInt32] = [7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
                                    5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
                                    4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
                                    6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21]

    // binary integer part of the sines of integers (Radians)
    private let sines: [UInt32] = [0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
                                   0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
                                   0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
                                   0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
                                   0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
                                   0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
                                   0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
                                   0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
                                   0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
                                   0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
                                   0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x4881d05,
                                   0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
                                   0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
                                   0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
                                   0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
                                   0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391]

    private let hashes: [UInt32] = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476]

    func calculate() -> [UInt8] {
        var tmpMessage = prepare(64)
        tmpMessage.reserveCapacity(tmpMessage.count + 4)

        // hash values
        var hh = hashes

        // Step 2. Append Length a 64-bit representation of lengthInBits
        let lengthInBits = (message.count * 8)
        let lengthBytes = lengthInBits.bytes(64 / 8)
        tmpMessage += lengthBytes.reversed()

        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64

        for chunk in BytesSequence(chunkSize: chunkSizeBytes, data: tmpMessage) {
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15
            let M = toUInt32Array(chunk)
            assert(M.count == 16, "Invalid array")

            // Initialize hash value for this chunk:
            var A: UInt32 = hh[0]
            var B: UInt32 = hh[1]
            var C: UInt32 = hh[2]
            var D: UInt32 = hh[3]

            var dTemp: UInt32 = 0

            // Main loop
            for j in 0 ..< sines.count {
                var g = 0
                var F: UInt32 = 0

                switch j {
                case 0...15:
                    F = (B & C) | ((~B) & D)
                    g = j
                    break
                case 16...31:
                    F = (D & B) | (~D & C)
                    g = (5 * j + 1) % 16
                    break
                case 32...47:
                    F = B ^ C ^ D
                    g = (3 * j + 5) % 16
                    break
                case 48...63:
                    F = C ^ (B | (~D))
                    g = (7 * j) % 16
                    break
                default:
                    break
                }
                dTemp = D
                D = C
                C = B
                B = B &+ rotateLeft((A &+ F &+ sines[j] &+ M[g]), bits: shifts[j])
                A = dTemp
            }

            hh[0] = hh[0] &+ A
            hh[1] = hh[1] &+ B
            hh[2] = hh[2] &+ C
            hh[3] = hh[3] &+ D
        }
        var result = [UInt8]()
        result.reserveCapacity(hh.count / 4)

        hh.forEach {
            let itemLE = $0.littleEndian
            let r1 = UInt8(itemLE & 0xff)
            let r2 = UInt8((itemLE >> 8) & 0xff)
            let r3 = UInt8((itemLE >> 16) & 0xff)
            let r4 = UInt8((itemLE >> 24) & 0xff)
            result += [r1, r2, r3, r4]
        }
        return result
    }
    
    func prepare(_ len: Int) -> [UInt8] {
        var tmpMessage = message

        // Step 1. Append Padding Bits
        tmpMessage.append(0x80) // append one bit (UInt8 with one bit) to message

        // append "0" bit until message length in bits ≡ 448 (mod 512)
        var msgLength = tmpMessage.count
        var counter = 0

        while msgLength % len != (len - 8) {
            counter += 1
            msgLength += 1
        }

        tmpMessage += [UInt8](repeating: 0, count: counter)
        return tmpMessage
    }
}

struct BytesSequence: Sequence {
    let chunkSize: Int
    let data: [UInt8]

    func makeIterator() -> BytesIterator {
        return BytesIterator(chunkSize: chunkSize, data: data)
    }
}

struct BytesIterator: IteratorProtocol {

    let chunkSize: Int
    let data: [UInt8]

    init(chunkSize: Int, data: [UInt8]) {
        self.chunkSize = chunkSize
        self.data = data
    }

    var offset = 0

    mutating func next() -> ArraySlice<UInt8>? {
        let end = min(chunkSize, data.count - offset)
        let result = data[offset..<offset + end]
        offset += result.count
        return result.count > 0 ? result : nil
    }
}

func rotateLeft(_ value: UInt32, bits: UInt32) -> UInt32 {
    return ((value << bits) & 0xFFFFFFFF) | (value >> (32 - bits))
}

extension Int {
    // Array of bytes with optional padding (little-endian)
    func bytes(_ totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
        return arrayOfBytes(self, length: totalBytes)
    }

}


// array of bytes, little-endian representation
func arrayOfBytes<T>(_ value: T, length: Int? = nil) -> [UInt8] {
    let totalBytes = length ?? (MemoryLayout<T>.size * 8)

    let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
    valuePointer.pointee = value

    let bytes = valuePointer.withMemoryRebound(to: UInt8.self, capacity: totalBytes) { (bytesPointer) -> [UInt8] in
        var bytes = [UInt8](repeating: 0, count: totalBytes)
        for j in 0..<min(MemoryLayout<T>.size, totalBytes) {
            bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
        }
        return bytes
    }

    #if swift(>=4.1)
    valuePointer.deinitialize(count: 1)
    valuePointer.deallocate()
    #else
    valuePointer.deinitialize()
    valuePointer.deallocate(capacity: 1)
    #endif

    return bytes
}

func toUInt32Array(_ slice: ArraySlice<UInt8>) -> [UInt32] {
    var result = [UInt32]()
    result.reserveCapacity(16)

    for idx in stride(from: slice.startIndex, to: slice.endIndex, by: MemoryLayout<UInt32>.size) {
        let d0 = UInt32(slice[idx.advanced(by: 3)]) << 24
        let d1 = UInt32(slice[idx.advanced(by: 2)]) << 16
        let d2 = UInt32(slice[idx.advanced(by: 1)]) << 8
        let d3 = UInt32(slice[idx])
        let val: UInt32 = d0 | d1 | d2 | d3

        result.append(val)
    }
    return result
}

let someError = NSError(domain: "", code: 0, userInfo: nil)
