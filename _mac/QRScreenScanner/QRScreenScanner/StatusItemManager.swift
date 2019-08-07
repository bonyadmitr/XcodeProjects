import Cocoa

final class StatusItemManager {
    
    //static let shared = StatusItemManager()
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    /// without storyboard can be create by lazy var + `_ = statusItem`.
    /// otherwise will be errors "0 is not a valid connection ID".
    /// https://habr.com/ru/post/447754/
    func setup() {
        guard let button = statusItem.button else {
            assertionFailure("system error. try statusItem.title")
            return
        }
        //button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        button.title = "QR"
        button.action = #selector(clickStatusItem)
        button.target = self
    }
    
    @objc private func clickStatusItem() {
        QRService.scanWindows()
    }

}

final class QRService {
    
    static func scanWindows() {
        let qrValues = ScreenManager
            .getHiddenWindowsImages()
            .flatMap { CodeDetector.shared.readQR(from: $0) }
        saveQRValues(qrValues)
        App.shared.showWindow()
    }
    
    static func scanDisplays() {
        let qrValues = ScreenManager
            .allDisplayImages()
            .flatMap { CodeDetector.shared.readQR(from: $0) }
        saveQRValues(qrValues)
        App.shared.showWindow()
    }
    
    private static func saveQRValues(_ qrValues: [String]) {
        let qrDataSources = qrValues.map { qrValue -> HistoryDataSource in
            [TableColumns.date.rawValue: Date(),TableColumns.value.rawValue: qrValue]
        }
        let tableDataSource: [HistoryDataSource]
        if let tableDataSourceOld = UserDefaults.standard.array(forKey: "historyDataSource") as? [HistoryDataSource] {
            tableDataSource = tableDataSourceOld + qrDataSources
        } else {
            tableDataSource = qrDataSources
        }
        UserDefaults.standard.set(tableDataSource, forKey: "historyDataSource")
    }
}
