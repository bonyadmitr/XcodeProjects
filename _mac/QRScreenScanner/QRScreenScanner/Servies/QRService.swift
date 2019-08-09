import Foundation

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
