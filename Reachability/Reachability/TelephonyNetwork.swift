import CoreTelephony

extension TelephonyNetwork {
    static let shared = TelephonyNetwork()
}

/// !!! CTRadioAccessTechnologyDidChange called on every creation of CTTelephonyNetworkInfo
final class TelephonyNetwork {
    
    enum CellularType {
        case none, g2, g3, g4, unknown
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
