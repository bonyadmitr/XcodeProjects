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
