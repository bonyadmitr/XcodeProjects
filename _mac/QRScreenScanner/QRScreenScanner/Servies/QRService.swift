import Foundation
import AppKit.NSImage

final class QRService {
    
    static func scanWindows() {
        let qrValues = SystemWindowsManager
            .getHiddenWindowsImages()
            .flatMap { CodeDetector.shared.readQR(from: $0) }
        saveQRValues(qrValues)
        App.shared.showWindow()
        playSound(for: qrValues)
    }
    
    static func scanDisplays() {
        let qrValues = ScreenManager
            .allDisplayImages()
            .flatMap { CodeDetector.shared.readQR(from: $0) }
        saveQRValues(qrValues)
        App.shared.showWindow()
        playSound(for: qrValues)
    }
    
    static func scanBrowser() {
        let qrValues = SystemWindowsManager
            .windowsForBundleId(System.defalutBrowserBundleId())
            .flatMap { CodeDetector.shared.readQR(from: $0) }
        saveQRValues(qrValues)
        App.shared.showWindow()
        playSound(for: qrValues)
    }
    
    static func scanFiles(at filePaths: [String]) {
        DispatchQueue.global().async {
            let qrDataSources = filePaths
                .compactMap { FileManager.default.contents(atPath: $0) }
                .compactMap { NSImage(data: $0) }
                .flatMap { CodeDetector.shared.readQR(from: $0) }
                .map { qrValue -> History in
                    History(date: Date(), value: qrValue)
            }
            DispatchQueue.main.async {
                HistoryDataSource.shared.history += qrDataSources
                playSound(for: qrDataSources)
            }
        }
    }
    
    static func scanImages(_ images: [NSImage]) {
        DispatchQueue.global().async {
            let qrDataSources = images
                .flatMap { CodeDetector.shared.readQR(from: $0) }
                .map { qrValue -> History in
                    History(date: Date(), value: qrValue)
            }
            DispatchQueue.main.async {
                HistoryDataSource.shared.history += qrDataSources
                playSound(for: qrDataSources)
            }
        }
    }
    
    private static func saveQRValues(_ qrValues: [String]) {
        let qrDataSources = qrValues.map { qrValue -> History in
            History(date: Date(), value: qrValue)
        }
        HistoryDataSource.shared.history += qrDataSources
    }
    
    private static func playSound(for qrValues: [Any]) {
        qrValues.isEmpty ? NSSound.playError() : NSSound.playSuccess()
    }
}
