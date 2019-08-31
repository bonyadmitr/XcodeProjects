import Foundation
import AppKit.NSImage

final class QRService: NSObject {
    
    static var item: DispatchWorkItem?
    
    static func scanWindowsDelayed() {
        /// or #1
        /// DispatchWorkItem cancel https://stackoverflow.com/a/38372384/5893286
        item?.cancel()
        
        let item = DispatchWorkItem {
            if self.item?.isCancelled == true {
                /// not called for REPLACED item (item = DispatchWorkItem.init)
                assertionFailure("- canceled")
                return
            }
            scanWindows()
        }
        self.item = item
        /// 0.1 is too fast for .asyncAfter
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: item)
        
        /// or #2
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(scanWindows), object: nil)
//        perform(#selector(scanWindows), with: nil, afterDelay: 0.1)
    }
    
    @objc static func scanWindows() {
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
    
    // TODO: optmized code for qrDataSourcesFiles
    ///  created no guard playError if there is at least one qrValue
    static func scan(filesAt filePaths: [String], images: [NSImage]) {
        DispatchQueue.global().async {
            let qrDataSourcesFiles = filePaths
                .compactMap { FileManager.default.contents(atPath: $0) }
                .compactMap { NSImage(data: $0) }
                .flatMap { CodeDetector.shared.readQR(from: $0) }
                .map { qrValue -> History in
                    History(date: Date(), value: qrValue)
            }
            let qrDataSourcesImages = images
                .flatMap { CodeDetector.shared.readQR(from: $0) }
                .map { qrValue -> History in
                    History(date: Date(), value: qrValue)
            }
            let qrDataSources = qrDataSourcesFiles + qrDataSourcesImages
            DispatchQueue.main.async {
                HistoryDataSource.shared.history += qrDataSources
                playSound(for: qrDataSources)
            }
        }
    }
    
    static func scanFiles(at filePaths: [String]) {
        if filePaths.isEmpty {
            return
        }
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
        if images.isEmpty {
            return
        }
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
