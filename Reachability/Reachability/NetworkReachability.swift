#if !os(watchOS)

import SystemConfiguration
import Foundation

public protocol NetworkReachabilityListener {
    /// called on private serial queue
    /// for simulator:
    /// - will NOT be called when connection appears
    /// - will BE called when connection disappears
    func networkReachabilityChangedConnection(_ networkReachability: NetworkReachability)
}

// MARK: - shared
extension NetworkReachability {
    static let shared = NetworkReachability()
    //static let shared = NetworkReachability(hostname: "www.google.com")
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
        guard self.flags != flags else {
            return
        }
        self.flags = flags
        reachabilityChanged()
    }
    
    private func reachabilityChanged() {
        self.connection = flags.connection()
        self.multicastDelegate.invokeDelegates { $0.networkReachabilityChangedConnection(self) }
    }
}

// MARK: - checkInternet
extension NetworkReachability {
    
    /// needs 3-4 kb of network for check
    func checkInternetConnection(handler: @escaping (_ isReachable: Bool) -> Void) {
//        let servers = Resolver().getservers().map(Resolver.getnameinfo)
//        print("- servers count: ", servers.count)
//        let q = servers.first ?? "https://www.google.com"
//        guard let url = URL(string: "https://\(q)") else {
        
        /// for china use https://www.wechat.com or something else
        //let urlString = "https://www.apple.com/library/test/success.html"
        let urlString = "https://www.google.com"
        guard let url = URL(string: urlString) else {
            assertionFailure()
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 1
        urlRequest.httpMethod = "HEAD"
        //urlRequest.cachePolicy = .reloadRevalidatingCacheData
        //urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        URLSession.shared.dataTask(with: urlRequest) { _, _, error in
            
            if let error = error as? URLError, error.code == .timedOut {
                handler(false)
            } else {
                handler(true)
            }
            
            //guard let error = error as? URLError else {
            //    self.view.backgroundColor = .green
            //    return
            //}
            //
            //switch error.code {
            //case .timedOut:
            //    print("there is no INTERNET connection or it is very slow")
            //case .notConnectedToInternet:
            //    print("there is no NETWORK connection at all")
            //default:
            //    print(error.localizedDescription)
            //}
        }.resume()
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

import Network

/// https://stackoverflow.com/a/55039596/5893286
/// https://developer.apple.com/documentation/network
@available(iOS 12.0, *)
class NetworkReachability2 {
    
    static let shared = NetworkReachability2()
    
    private let pathMonitor = NWPathMonitor()
    //private let pathMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
    
    private var path: NWPath
    
//    func qqq(path: NWPath) -> Void {
//
//    }
    
//    private lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
//        print(path)
//    }
    
    //var connection = Network.NWInterface.InterfaceType.other
    var connection: NetworkReachability.Connection
    
    private let listeningQueue = DispatchQueue(label: "reachability2_private_serial_queue")
    
    init() {
        path = pathMonitor.currentPath
        connection = pathMonitor.currentPath.typeForiOS()
        
        /// when changing from .unsatisfied to .satisfied can be called many times(I saw up to 3)
        pathMonitor.pathUpdateHandler = { [weak self] path in
            /// "self.path" will never be equals "path",
            /// so don't use "guard self?.path != path"
            self?.path = path
//            print("-", path.status)
            

            let newConnection = path.typeForiOS()
            guard self?.connection != newConnection else {
                /// will be called if wifi in on and cellular turned off.
                /// also when system calls pathUpdateHandler few times.
                return
            }
            self?.connection = newConnection
            print(newConnection)
//            print("-12:", path.typeForiOS())
            
            /// on iOS device requiresConnection called when quckly turn on/off cellular internet usage
//            switch path.status {
//            case .satisfied:
//                print("-12:", "Connected")
//            case .unsatisfied:
//                print("-12:", "unsatisfied")
//
//            case .requiresConnection:
//                print("-12:", "requiresConnection")
//            }
//            print("-12:", path.availableInterfaces.compactMap { $0.type })
//            print()
            
//            print("isExpensive", path.isExpensive)
        }
        
        pathMonitor.start(queue: listeningQueue)
    }
    
    func isNetworkAvailable() -> Bool {
        return path.status == .satisfied
    }
}

@available(iOS 12.0, *)
extension NWPath {
    func typeForiOS() -> NetworkReachability.Connection {
        if availableInterfaces.contains(where: { $0.type == .wifi }) {
            return .wifi
        } else if availableInterfaces.contains(where: { $0.type == .cellular }) {
            return .cellular
        } else {
//            assertionFailure("should never called. check connection status before check")
            return .none
        }
    }
}
