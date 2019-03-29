#if !os(watchOS)

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

// MARK: - shared
extension NetworkReachability {
    static let shared = NetworkReachability()
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
    
    /// working without startListening but only on init.
    /// will be up to date after startListening.
    /// for simulator will be only WiFi.
    public var connection: Connection
    
    private var isListeningStarted = false
    private let reachability: SCNetworkReachability
    private let listeningQueue = DispatchQueue(label: "reachability_private_serial_queue")
    private let multicastDelegate = MulticastDelegate<NetworkReachabilityListener>()
    
    private var flags: SCNetworkReachabilityFlags
    
    // MARK: - Init methods
    
    /// Reachability treats the 0.0.0.0 address as a special token that causes it to monitor the general routing status of the device, both IPv4 and IPv6.
    public convenience init?() {
        /// #1
        //var zeroAddress = sockaddr_in()
        //zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        //zeroAddress.sin_family = sa_family_t(AF_INET)
        //
        //guard let reachability = withUnsafePointer(to: &zeroAddress, {
        //    $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        //        SCNetworkReachabilityCreateWithAddress(nil, $0)
        //    }}) else { return nil }
        
        /// #2
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else {
            return nil
        }
        
        self.init(reachability: reachability)
    }
    
    public convenience init?(hostname: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            return nil
        }
        self.init(reachability: reachability)
    }
    
    init?(reachability: SCNetworkReachability) {
        self.reachability = reachability
        
        /// get flags
        var flags = SCNetworkReachabilityFlags()
        let isFlagsUpdated = SCNetworkReachabilityGetFlags(self.reachability, &flags)
        self.flags = flags
        
        /// flags didSet will not be called
        self.connection = flags.connection()
        
        if !isFlagsUpdated {
            assertionFailure()
            return nil
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
    
    /// don't need directly unregister objects.
    /// call it when you need it directly.
    func unregister(_ delegate: NetworkReachabilityListener) {
        multicastDelegate.removeDelegate(delegate)
    }
}

// MARK: - Listening methods
public extension NetworkReachability {
    
    @discardableResult
    func startListening() -> Bool {
        if isListeningStarted {
            assertionFailure("don't need to start twice")
            return true
        }
        
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        /// #1
        context.info = UnsafeMutableRawPointer(Unmanaged<NetworkReachability>.passUnretained(self).toOpaque())
        /// #2
        //context.info = Unmanaged.passUnretained(self).toOpaque()
        
        /// SystemConfiguration callback will be here
        let callback: SCNetworkReachabilityCallBack = { _, flags, info in
            guard let info = info else {
                assertionFailure("SystemConfiguration bug")
                return
            }
            Unmanaged<NetworkReachability>.fromOpaque(info).takeUnretainedValue().updateFlags(with: flags)
        }
        
        let callbackEnabled = SCNetworkReachabilitySetCallback(reachability, callback, &context)
        let queueEnabled = SCNetworkReachabilitySetDispatchQueue(reachability, listeningQueue)
        
        isListeningStarted = callbackEnabled && queueEnabled
        return isListeningStarted
    }
    
    func stopListening() {
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        isListeningStarted = false
    }
    
    private func updateFlags(with flags: SCNetworkReachabilityFlags) {
        guard self.flags != flags else { return }
        self.flags = flags
        reachabilityChanged()
    }
    
    private func reachabilityChanged() {
        self.connection = flags.connection()
        self.multicastDelegate.invokeDelegates { $0.networkReachability(self, changed: self.connection) }
    }
}

// MARK: - SCNetworkReachabilityFlags+Connection
private extension SCNetworkReachabilityFlags {
    
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

//import Foundation

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

    func invokeDelegates(_ invocation: (T) -> ()) {
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

#endif
