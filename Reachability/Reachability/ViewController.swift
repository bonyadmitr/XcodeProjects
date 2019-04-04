import UIKit
import Connectivity

class ViewController: UIViewController {
    
    /// https://stackoverflow.com/a/52625314/5893286
    /// https://github.com/rwbutler/Connectivity
    /// https://medium.com/@rwbutler/solving-the-captive-portal-problem-on-ios-9a53ba2b381e
    let connectivity: Connectivity = Connectivity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 12.0, *) {
            _ = NetworkReachability2.shared
        } else {
            setupNetworkReachability()
        }
        
//        let connectivityChanged: (Connectivity) -> Void = { [weak self] connectivity in
//            self?.updateConnectionStatus(connectivity.status)
//        }
//
//        connectivity.whenConnected = connectivityChanged
//        connectivity.whenDisconnected = connectivityChanged
//
//        connectivity.startNotifier()
    }
    
    func updateConnectionStatus(_ status: ConnectivityStatus) {
        print(status)
        
        switch status {
        case .connected:
            view.backgroundColor = .cyan
        case .connectedViaCellular:
            view.backgroundColor = .yellow
        case .connectedViaCellularWithoutInternet:
            view.backgroundColor = .red
        case .connectedViaWiFi:
            view.backgroundColor = .green
        case .connectedViaWiFiWithoutInternet:
            view.backgroundColor = .red
        case .notConnected:
            view.backgroundColor = .red
        }
    }

    
    private func setupNetworkReachability() {
        guard let networkReachability = NetworkReachability.shared else  {
            assertionFailure()
            return
        }
        networkReachability.register(self)
        updateUserInterface(for: networkReachability)
    }
    
    private func updateUserInterface(for networkReachability: NetworkReachability) {
        switch networkReachability.connection {
        case .none:
            view.backgroundColor = .red
        case .cellular:
            view.backgroundColor = .yellow
        case .wifi:
            networkReachability.checkInternetConnection { [weak self] isReachable in
                DispatchQueue.main.async {
                    if isReachable {
                        self?.view.backgroundColor = .green
                    } else {
                        self?.view.backgroundColor = .red
                    }
                }
            }
        }
        
        print(networkReachability.connection)
//        print(TelephonyNetwork.shared.checkCellularType())
    }
}

extension ViewController: NetworkReachabilityListener {
    func networkReachabilityChangedConnection(_ networkReachability: NetworkReachability) {
        DispatchQueue.main.async {
            self.updateUserInterface(for: networkReachability)
        }
    }
}

/// https://stackoverflow.com/a/41303040/5893286
/// also needs Reachability-Bridging-Header.h with:
/// #include <resolv.h>
open class Resolver {
    
    fileprivate var state = __res_9_state()
    
    public init() {
        res_9_ninit(&state)
    }
    
    deinit {
        res_9_ndestroy(&state)
    }
    
    public final func getservers() -> [res_9_sockaddr_union] {
        
        let maxServers = 10
        var servers = [res_9_sockaddr_union](repeating: res_9_sockaddr_union(), count: maxServers)
        let found = Int(res_9_getservers(&state, &servers, Int32(maxServers)))
        
        // filter is to remove the erroneous empty entry when there's no real servers
        return Array(servers[0 ..< found]).filter() { $0.sin.sin_len > 0 }
    }
}

extension Resolver {
    public static func getnameinfo(_ s: res_9_sockaddr_union) -> String {
        var s = s
        var hostBuffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        
        let sinlen = socklen_t(s.sin.sin_len)
        let _ = withUnsafePointer(to: &s) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.getnameinfo($0, sinlen,
                                   &hostBuffer, socklen_t(hostBuffer.count),
                                   nil, 0,
                                   NI_NUMERICHOST)
            }
        }
        
        return String(cString: hostBuffer)
    }
}
