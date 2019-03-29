//
//  NetworkReachability.swift
//  NetworkReachability
//
//  Created by Bondar Yaroslav on 3/29/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import SystemConfiguration
import Foundation

public protocol NetworkReachabilityListener {
    /// called on private serial queue
    /// for simulator:
    /// - will NOT be called when connection appears
    /// - will BE called when connection disappears
    func networkReachability(_ networkReachability: NetworkReachability,
                             changed connection: NetworkReachability.Connection)
}

// MARK: -

/// https://stackoverflow.com/a/30743763/5893286
/// https://github.com/ashleymills/Reachability.swift/blob/master/Sources/Reachability.swift
/// https://github.com/Alamofire/Alamofire/blob/master/Source/NetworkReachabilityManager.swift
public class NetworkReachability {
    
    public enum Connection: CustomStringConvertible {
        /// "wifi" must be named "ethernetOrWiFi"
        case none, wifi, cellular
        
        public var description: String {
            switch self {
            case .cellular: return "Cellular"
            case .wifi: return "WiFi"
            case .none: return "No Connection"
            }
        }
    }
    
    public enum InitErrors: Error {
        case errorInSystemFramework
        case unableToGetFlags
    }
    
    public enum StartErrors: Error {
        case unableToSetCallback
        case unableToSetDispatchQueue
    }
    
    /// working without startListening but only on init.
    /// will be up to date after startListening.
    /// for simulator will be only WiFi.
    public var connection: Connection
    
    private var notifierRunning = false
    private let reachability: SCNetworkReachability
    private let reachabilitySerialQueue = DispatchQueue(label: "reachability_private_serial_queue")
    private let multicastDelegate = MulticastDelegate<NetworkReachabilityListener>()
    
    private var flags: SCNetworkReachabilityFlags {
        didSet {
            guard flags != oldValue else { return }
            reachabilityChanged()
        }
    }
    
    private func reachabilityChanged() {
        self.connection = flags.connection()
        self.multicastDelegate.invokeDelegates { $0.networkReachability(self, changed: self.connection) }
    }
    
    /// Reachability treats the 0.0.0.0 address as a special token that causes it to monitor the general routing status of the device, both IPv4 and IPv6.
    public convenience init() throws {
        /// #1
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        guard let reachability = withUnsafePointer(to: &zeroAddress, {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
//                SCNetworkReachabilityCreateWithAddress(nil, $0)
//            }}) else { return nil }
        
        /// #2
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else {
            throw InitErrors.errorInSystemFramework
        }
        try self.init(reachability: reachability)
    }
    
    public convenience init(hostname: String) throws {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            throw InitErrors.errorInSystemFramework
        }
        try self.init(reachability: reachability)
    }
    
    init(reachability: SCNetworkReachability) throws {
        self.reachability = reachability
        
        /// get flags
        var flags = SCNetworkReachabilityFlags()
        let isFlagsUpdated = SCNetworkReachabilityGetFlags(self.reachability, &flags)
        self.flags = flags
        
        /// flags didSet will not be called
        self.connection = flags.connection()
        
        if !isFlagsUpdated {
            assertionFailure()
            throw InitErrors.unableToGetFlags
        }
    }
    
    deinit {
        stopListening()
    }
}

// MARK: - Delegate methods
public extension NetworkReachability {
    func register(_ delegate: NetworkReachabilityListener) {
        multicastDelegate.addDelegate(delegate)
    }
    func unregister(_ delegate: NetworkReachabilityListener) {
        multicastDelegate.removeDelegate(delegate)
    }
}

// MARK: - Notifier methods
public extension NetworkReachability {
    
    func startListening() throws {
        guard !notifierRunning else {
            assertionFailure("don't need to start twice")
            return
        }
        
        let callback: SCNetworkReachabilityCallBack = { _, flags, info in
            guard let info = info else {
                assertionFailure()
                return
            }
            Unmanaged<NetworkReachability>.fromOpaque(info).takeUnretainedValue().flags = flags
        }
        
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged<NetworkReachability>.passUnretained(self).toOpaque())
        
        if !SCNetworkReachabilitySetCallback(reachability, callback, &context) {
            stopListening()
            throw StartErrors.unableToSetCallback
        }
        
        if !SCNetworkReachabilitySetDispatchQueue(reachability, reachabilitySerialQueue) {
            stopListening()
            throw StartErrors.unableToSetDispatchQueue
        }
        
        notifierRunning = true
    }
    
    func stopListening() {
        defer { notifierRunning = false }
        
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
    }
}

// MARK: - shared
extension NetworkReachability {
    static let shared = try? NetworkReachability()
}

// MARK: - SCNetworkReachabilityFlags+Connection
extension SCNetworkReachabilityFlags {
    
    func isNetworkReachable() -> Bool {
        let isReachable = contains(.reachable)
        let needsConnection = contains(.connectionRequired)
        let canConnectAutomatically = contains(.connectionOnDemand) || contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    func connection() -> NetworkReachability.Connection {
        guard isNetworkReachable() else {
            return .none
        }
        
        /// If we're reachable, but not on a device (i.e. simulator), we must be on WiFi
        #if targetEnvironment(simulator)
        return .wifi
        #else
        return isCellular() ? .cellular :  .wifi
        #endif
    }
    
    /// iPhone and iPad can have cellular network
    func isCellular() -> Bool {
        #if os(iOS)
        return contains(.isWWAN)
        #else
        return false
        #endif
    }
}

// MARK: -

import Foundation

/// https://github.com/jonasman/MulticastDelegate/blob/master/Sources/MulticastDelegate.swift
private final class MulticastDelegate<T> {
    private let delegates = NSHashTable<AnyObject>.weakObjects()

    /// will not add two same objects
    /// Value Types will be ignored
    func addDelegate(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    func removeDelegate(_ delegate: T) {
        delegates.remove(delegate as AnyObject)
    }

    public func invokeDelegates(_ invocation: (T) -> ()) {
        for delegate in delegates.allObjects {
            /// for performance can be used unsafe invocation(delegate as! T)
            if let delegate = delegate as? T {
                invocation(delegate)
            } else {
                assertionFailure("delegate is not T")
            }
        }
    }
}
