//
//  Reachability.swift
//  Reachability
//
//  Created by Bondar Yaroslav on 3/29/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Foundation

import Foundation
import SystemConfiguration

/// https://stackoverflow.com/a/30743763/5893286
/// https://github.com/ashleymills/Reachability.swift/blob/master/Sources/Reachability.swift
import SystemConfiguration
import Foundation

public enum ReachabilityError: Error {
    case FailedToSystemFramework
    case UnableToSetCallback
    case UnableToSetDispatchQueue
    case UnableToGetInitialFlags
}

public protocol ReachabilitySubscriber {
    /// called on private serial queue
    func reachabilityChanged(_ reachability: Reachability)
}

public class Reachability {
    
    public enum Connection: CustomStringConvertible {
        case none, wifi, cellular
        
        public var description: String {
            switch self {
            case .cellular: return "Cellular"
            case .wifi: return "WiFi"
            case .none: return "No Connection"
            }
        }
    }
    
    public var connection: Connection
    
    private var notifierRunning = false
    private let reachability: SCNetworkReachability
    private let reachabilitySerialQueue = DispatchQueue(label: "reachability_private_serial_queue")
    private let multicastDelegate = MulticastDelegate<ReachabilitySubscriber>()
    
    private var flags: SCNetworkReachabilityFlags {
        didSet {
            guard flags != oldValue else { return }
            reachabilityChanged()
        }
    }
    
    private func reachabilityChanged() {
        self.connection = flags.connection
        self.multicastDelegate.invokeDelegates { $0.reachabilityChanged(self) }
    }
    
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
            throw ReachabilityError.FailedToSystemFramework
        }
        try self.init(reachability: reachability)
    }
    
    public convenience init(hostname: String) throws {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            throw ReachabilityError.FailedToSystemFramework
        }
        try self.init(reachability: reachability)
    }
    
    init(reachability: SCNetworkReachability) throws {
        self.reachability = reachability
        
        var flags = SCNetworkReachabilityFlags()
        let isFlagsUpdated = SCNetworkReachabilityGetFlags(self.reachability, &flags)
        self.flags = flags
        self.connection = flags.connection
        
        if !isFlagsUpdated {
            assertionFailure()
            throw ReachabilityError.UnableToGetInitialFlags
        }
    }
    
    deinit {
        stopNotifier()
    }
}

public extension Reachability {
    func register(_ delegate: ReachabilitySubscriber) {
        multicastDelegate.addDelegate(delegate)
    }
    func unregister(_ delegate: ReachabilitySubscriber) {
        multicastDelegate.removeDelegate(delegate)
    }
}

public extension Reachability {
    
    func startNotifier() throws {
        guard !notifierRunning else {
            assertionFailure()
            return
        }
        
        let callback: SCNetworkReachabilityCallBack = { (reachability, flags, info) in
            guard let info = info else {
                assertionFailure()
                return
            }
            Unmanaged<Reachability>
                .fromOpaque(info)
                .takeUnretainedValue()
                .flags = flags
        }
        
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged<Reachability>.passUnretained(self).toOpaque())
        if !SCNetworkReachabilitySetCallback(reachability, callback, &context) {
            stopNotifier()
            throw ReachabilityError.UnableToSetCallback
        }
        
        if !SCNetworkReachabilitySetDispatchQueue(reachability, reachabilitySerialQueue) {
            stopNotifier()
            throw ReachabilityError.UnableToSetDispatchQueue
        }
        
        notifierRunning = true
    }
    
    func stopNotifier() {
        defer { notifierRunning = false }
        
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
    }
}

extension Reachability {
    static let shared = try? Reachability()
}

extension SCNetworkReachabilityFlags {
    
    typealias Connection = Reachability.Connection
    
    var connection: Connection {
        guard isReachableFlagSet else { return .none }
        
        // If we're reachable, but not on an iOS device (i.e. simulator), we must be on WiFi
        #if targetEnvironment(simulator)
        return .wifi
        #else
        
        var connection = Connection.none
        
        if !isConnectionRequiredFlagSet {
            connection = .wifi
        }
        
        if isConnectionOnTrafficOrDemandFlagSet {
            if !isInterventionRequiredFlagSet {
                connection = .wifi
            }
        }
        
        if isOnWWANFlagSet {
            connection = .cellular
        }
        
        return connection
        #endif
    }
    
    var isOnWWANFlagSet: Bool {
        #if os(iOS)
        return contains(.isWWAN)
        #else
        return false
        #endif
    }
    var isReachableFlagSet: Bool {
        return contains(.reachable)
    }
    var isConnectionRequiredFlagSet: Bool {
        return contains(.connectionRequired)
    }
    var isInterventionRequiredFlagSet: Bool {
        return contains(.interventionRequired)
    }
    var isConnectionOnTrafficFlagSet: Bool {
        return contains(.connectionOnTraffic)
    }
    var isConnectionOnDemandFlagSet: Bool {
        return contains(.connectionOnDemand)
    }
    var isConnectionOnTrafficOrDemandFlagSet: Bool {
        return !intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    var isTransientConnectionFlagSet: Bool {
        return contains(.transientConnection)
    }
    var isLocalAddressFlagSet: Bool {
        return contains(.isLocalAddress)
    }
    var isDirectFlagSet: Bool {
        return contains(.isDirect)
    }
    var isConnectionRequiredAndTransientFlagSet: Bool {
        return intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }
}


import Foundation

/// https://github.com/jonasman/MulticastDelegate/blob/master/Sources/MulticastDelegate.swift
final class MulticastDelegate<T> {
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
