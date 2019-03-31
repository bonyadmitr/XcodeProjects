import CoreTelephony

extension TelephonyNetwork {
    static let shared = TelephonyNetwork()
}

/// !!! CTRadioAccessTechnologyDidChange called on every creation of CTTelephonyNetworkInfo
/// will be a lot of errors on the simulator due creation of CTTelephonyNetworkInfo
/// so use "#if !targetEnvironment(simulator) #endif"
final class TelephonyNetwork {
    
    /// can't be named cases like 3G or 4G due the language
    enum CellularType: CustomStringConvertible {
        case none, g2, g3, g4, unknown
        
        var description: String {
            switch self {
            case .none:
                return "No Connection"
            case .g2:
                return "2G"
            case .g3:
                return "3G"
            case .g4:
                return "4G"
            case .unknown:
                return "5G or Unknown"
            }
        }
    }
    
    var cellularType: CellularType = .none
    
    private let networkInfo = CTTelephonyNetworkInfo()
    private var notificationToken: NSObjectProtocol?
    
    init() {
        cellularType = cellularType(for: networkInfo.currentRadioAccessTechnology)
    }
    
    deinit {
        stopListening()
    }
    
    func startListening() {
        guard notificationToken == nil else {
            assertionFailure("don't need to start twice")
            return
        }
        
        /// object can contains currentRadioAccessTechnology or nil
        /// queue is CTTelephonyNetworkInfo(serial)
        NotificationCenter.default.addObserver(forName: .CTRadioAccessTechnologyDidChange, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else {
                return
            }
            self.cellularType = self.cellularType(for: notification.object as? String)
            print("Cellular changed:", self.cellularType)
        }
    }
    
    func stopListening() {
        if let notificationToken = notificationToken {
            NotificationCenter.default.removeObserver(notificationToken, name: .CTRadioAccessTechnologyDidChange, object: nil)
        }
    }
    
    private func cellularType(for technology: String?) -> CellularType {
        /// can be .none when changing to 2G
        guard let technology = technology else {
            return .none
        }
        
        /// https://stackoverflow.com/a/44646476/5893286
        switch technology {
        case CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyCDMA1x:
            return .g2
        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD:
            return .g3
        case CTRadioAccessTechnologyLTE:
            return .g4
        default:
            /// never called during the tests
            /// can be called for new networks like 5G
            return .unknown
        }
    }
}
