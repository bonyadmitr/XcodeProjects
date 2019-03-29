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
final class Reachability {
    
    private var isRunning = false
    private let isReachableOnWWAN: Bool
    private let reachability: SCNetworkReachability
    private let reachabilitySerialQueue = DispatchQueue(label: "ReachabilityQueue")
    
    init(hostname: String) throws {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            throw Network.Error.failedToCreateWith(hostname)
        }
        self.reachability = reachability
        isReachableOnWWAN = true
        try start()
    }
    
    init() throws {
        /// #1
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        guard let reachability = withUnsafePointer(to: &zeroAddress, {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
//                SCNetworkReachabilityCreateWithAddress(nil, $0)
//            }
        
        /// #2
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else {
            throw Network.Error.failedToSetCallout
            //throw Network.Error.failedToInitializeWith(zeroAddress)
        }
        
        self.reachability = reachability
        isReachableOnWWAN = true
        try start()
    }
    
    deinit {
        stop()
    }
    
    var status: Network.Status {
        // If we're reachable, but not on an iOS device (i.e. simulator), we must be on WiFi
//        #if targetEnvironment(simulator)
//        return .wifi
//        #else
        return !isConnectedToNetwork ? .unreachable :
            isReachableViaWiFi  ? .wifi :
            isRunningOnDevice   ? .wwan : .unreachable
//        #endif
    }
    
    var isRunningOnDevice: Bool = {
        #if targetEnvironment(simulator)
        return false
        #else
        return true
        #endif
    }()
    
    private let callback: SCNetworkReachabilityCallBack = { (reachability, flags, info) in
        guard let info = info else {
            assertionFailure()
            return
        }
        Unmanaged<Reachability>
            .fromOpaque(info)
            .takeUnretainedValue()
            .reachabilityLastFlags = flags
    }
    
    private var reachabilityLastFlags: SCNetworkReachabilityFlags? {
        didSet {
            guard flags != oldValue else { return }
            reachabilityChanged()
        }
    }
}

extension Reachability {
    
    func start() throws {
        guard !isRunning else { return }
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged<Reachability>.passUnretained(self).toOpaque()
        
        
        guard SCNetworkReachabilitySetCallback(reachability, callback, &context) else { stop()
//        guard SCNetworkReachabilitySetCallback(reachability, callout, &context) else { stop()
            throw Network.Error.failedToSetCallout
        }
        guard SCNetworkReachabilitySetDispatchQueue(reachability, reachabilitySerialQueue) else { stop()
            throw Network.Error.failedToSetDispatchQueue
        }
//        reachabilitySerialQueue.async { self.reachabilityChanged() }
        isRunning = true
    }
    
    func stop() {
        defer { isRunning = false }
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
    }
    
    var isConnectedToNetwork: Bool {
        return isReachable &&
            !isConnectionRequiredAndTransientConnection &&
            !(isRunningOnDevice && isWWAN && !isReachableOnWWAN)
    }
    
    var isReachableViaWiFi: Bool {
        return isReachable && isRunningOnDevice && !isWWAN
    }
    
    private func getReachabilityFlags() -> SCNetworkReachabilityFlags {
//        reachabilitySerialQueue.sync { [unowned self] in
//
//        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            assertionFailure("ReachabilityError.UnableToGetInitialFlags")
            //stop()
        }
        return flags
    }
    
    /// Flags that indicate the reachability of a network node name or address, including whether a connection is required, and whether some user intervention might be required when establishing a connection.
    var flags: SCNetworkReachabilityFlags {
        return reachabilityLastFlags ?? getReachabilityFlags()
//        var flags = SCNetworkReachabilityFlags()
//        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
//            assertionFailure("ReachabilityError.UnableToGetInitialFlags")
//            //stop()
//        }
//        return flags
//        self.flags = flags
        
        /// old one
//        var flags = SCNetworkReachabilityFlags()
//        return withUnsafeMutablePointer(to: &flags) {
//            SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0))
//            } ? flags : nil
    }
    
    /// compares the current flags with the previous flags and if changed posts a flagsChanged notification
    func reachabilityChanged() {
        NotificationCenter.default.post(name: .flagsChanged, object: self)
    }
    
    /// The specified node name or address can be reached via a transient connection, such as PPP.
    var transientConnection: Bool { return flags.contains(.transientConnection) == true }
    
    /// The specified node name or address can be reached using the current network configuration.
    var isReachable: Bool { return flags.contains(.reachable) == true }
    
    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. If this flag is set, the kSCNetworkReachabilityFlagsConnectionOnTraffic flag, kSCNetworkReachabilityFlagsConnectionOnDemand flag, or kSCNetworkReachabilityFlagsIsWWAN flag is also typically set to indicate the type of connection required. If the user must manually make the connection, the kSCNetworkReachabilityFlagsInterventionRequired flag is also set.
    var connectionRequired: Bool { return flags.contains(.connectionRequired) == true }
    
    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. Any traffic directed to the specified name or address will initiate the connection.
    var connectionOnTraffic: Bool { return flags.contains(.connectionOnTraffic) == true }
    
    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established.
    var interventionRequired: Bool { return flags.contains(.interventionRequired) == true }
    
    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. The connection will be established "On Demand" by the CFSocketStream programming interface (see CFStream Socket Additions for information on this). Other functions will not establish the connection.
    var connectionOnDemand: Bool { return flags.contains(.connectionOnDemand) == true }
    
    /// The specified node name or address is one that is associated with a network interface on the current system.
    var isLocalAddress: Bool { return flags.contains(.isLocalAddress) == true }
    
    /// Network traffic to the specified node name or address will not go through a gateway, but is routed directly to one of the interfaces in the system.
    var isDirect: Bool { return flags.contains(.isDirect) == true }
    
    /// The specified node name or address can be reached via a cellular connection, such as EDGE or GPRS.
    var isWWAN: Bool { return flags.contains(.isWWAN) == true }
    
    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. If this flag is set
    /// The specified node name or address can be reached via a transient connection, such as PPP.
    var isConnectionRequiredAndTransientConnection: Bool {
        return (flags.intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]) == true
    }
}

struct Network {
    static var reachability: Reachability!
    enum Status: String {
        case unreachable, wifi, wwan
    }
    enum Error: Swift.Error {
        case failedToSetCallout
        case failedToSetDispatchQueue
        case failedToCreateWith(String)
        case failedToInitializeWith(sockaddr_in)
    }
}

//private func callout(reachability: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) {
//    guard let info = info else { return }
//    DispatchQueue.main.async {
//        Unmanaged<Reachability>
//            .fromOpaque(info)
//            .takeUnretainedValue()
//            .flagsChanged()
//    }
//}

extension Notification.Name {
    static let flagsChanged = Notification.Name("FlagsChanged")
}
