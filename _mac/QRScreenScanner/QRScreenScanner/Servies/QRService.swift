import Foundation

final class QRService {
    
    static func scanWindows() {
        let qrValues = SystemWindowsManager
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
    
    static func scanBrowser() {
        if let windowImage = SystemWindowsManager.compositedWindowForBundleId(System.defalutBrowserBundleId()) {
            let qrValues = CodeDetector.shared.readQR(from: windowImage)
            saveQRValues(qrValues)
            App.shared.showWindow()
        }
    }
    
    private static func saveQRValues(_ qrValues: [String]) {
        let qrDataSources = qrValues.map { qrValue -> History in
            History(date: Date(), value: qrValue)
        }
        HistoryModel.shared.historyDataSource += qrDataSources
    }
}
