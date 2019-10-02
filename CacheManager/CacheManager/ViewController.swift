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


let someError = NSError(domain: "", code: 0, userInfo: nil)
