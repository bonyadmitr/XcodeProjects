import Foundation


/// Represents a set of conception related to storage which stores a certain type of value in disk.
/// This is a namespace for the disk storage types. A `Backend` with a certain `Config` will be used to describe the
/// storage. See these composed types for more information.
public enum DiskStorage {
    
//    static let shared = Backend<CrossPlatformImage>(

    /// Represents a storage back-end for the `DiskStorage`. The value is serialized to data
    /// and stored as file in the file system under a specified location.
    ///
    /// You can config a `DiskStorage.Backend` in its initializer by passing a `DiskStorage.Config` value.
    /// or modifying the `config` property after it being created. `DiskStorage` will use file's attributes to keep
    /// track of a file for its expiration or size limitation.
    public class Backend<T: DataTransformable> {
        /// The config used for this disk storage.
        public let config: Config

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
                throw DiskStorageErrors.cannotCreateDirectory(path: path, error: error)
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
                throw DiskStorageErrors.cannotConvertToData(object: value, error: error)
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
                throw DiskStorageErrors.invalidURLResource(key: key, url: fileURL, error: error)
            }

            if meta.expired(referenceDate: referenceDate) {
                return nil
            }
            if !actuallyLoad {
                return T.empty
            }

            do {
                let data = try Data(contentsOf: fileURL)
                let obj = try T.fromData(data)
                metaChangingQueue.async { meta.extendExpiration(with: fileManager, extendingExpiration: extendingExpiration) }
                return obj
            } catch {
                throw DiskStorageErrors.cannotLoadDataFromDisk(url: fileURL, error: error)
            }
        }

//        func isCached(forKey key: String) -> Bool {
//            return isCached(forKey: key, referenceDate: Date())
//        }

        func isCached(forKey key: String, referenceDate: Date = Date()) -> Bool {
            return (try? value(forKey: key, referenceDate: referenceDate, actuallyLoad: false, extendingExpiration: .none)) != nil
//            do {
//                guard let _ = try value(forKey: key, referenceDate: referenceDate, actuallyLoad: false, extendingExpiration: .none) else {
//                    return false
//                }
//                return true
//            } catch {
//                return false
//            }
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
                throw DiskStorageErrors.fileEnumeratorCreationFailed(url: directoryURL)
            }

            guard let urls = directoryEnumerator.allObjects as? [URL] else {
                throw DiskStorageErrors.invalidFileEnumeratorContent(url: directoryURL)
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

        var cachePathBlock: ((_ directory: URL, _ cacheName: String) -> URL) = {
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


// TODO: description
enum DiskStorageErrors: LocalizedError {
    case cannotCreateDirectory(path: String, error: Error)
    case invalidURLResource(key: String, url: URL, error: Error)
    case cannotLoadDataFromDisk(url: URL, error: Error)
    case fileEnumeratorCreationFailed(url: URL)
    case invalidFileEnumeratorContent(url: URL)
    case cannotConvertToData(object: Any, error: Error)
}

extension Data: DataTransformable {
    public func toData() throws -> Data {
        return self
    }

    public static func fromData(_ data: Data) throws -> Data {
        return data
    }

    public static let empty = Data()
}

/// can be done "heic", "heix", "hevc", "hevx"
public enum ImageFormat: String {
    case png, jpg, heic, unknown
}

extension ImageFormat {
    static func get(from data: Data) -> ImageFormat {
        switch data[0] {
        case 0x89:
            return .png
        case 0xFF:
            return .jpg
//        case 0x47:
//            return .gif
//        case 0x49, 0x4D:
//            return .tiff
//        case 0x52 where data.count >= 12:
//            let subdata = data[0...11]
//
//            if let dataString = String(data: subdata, encoding: .ascii),
//                dataString.hasPrefix("RIFF"),
//                dataString.hasSuffix("WEBP")
//            {
//                return .webp
//            }
            
        case 0x00 where data.count >= 12 :
            let subdata = data[8...11]
            
            if let dataString = String(data: subdata, encoding: .ascii),
                Set(["heic", "heix", "hevc", "hevx"]).contains(dataString)
                ///OLD: "ftypheic", "ftypheix", "ftyphevc", "ftyphevx"
            {
                return .heic
            }
        default:
            break
        }
        return .unknown
    }
    
    static func data(with image: CrossPlatformImage, original: Data?) -> Data? {
        if let original = original {
            return image.data(format: get(from: original))
        } else {
            return image.data(format: .unknown)
        }
    }
    

    
//    var contentType: String {
//        return "image/\(rawValue)"
//    }
    
//    var imageTypeForSave: String {
//        switch self {
//        case .unknown:
//            return ""
//        default:
//            return rawValue
//        }
//    }
}
