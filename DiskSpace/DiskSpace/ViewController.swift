//
//  ViewController.swift
//  DiskSpace
//
//  Created by Bondar Yaroslav on 3/20/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var sizeLabel1: UILabel!
    @IBOutlet private weak var sizeLabel2: UILabel!
    @IBOutlet private weak var sizeLabel3: UILabel!
    @IBOutlet private weak var sizeLabel4: UILabel!
    @IBOutlet private weak var sizeLabel5: UILabel!
    
    @IBOutlet private weak var titleLabel1: UILabel!
    @IBOutlet private weak var titleLabel2: UILabel!
    @IBOutlet private weak var titleLabel3: UILabel!
    @IBOutlet private weak var titleLabel4: UILabel!
    @IBOutlet private weak var titleLabel5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitles()
    }
    
    private func setTitles() {
        titleLabel1.text = "volumeAvailableCapacityKey"
        titleLabel2.text = "volumeAvailableCapacityForImportantUsageKey"
        titleLabel3.text = "volumeAvailableCapacityForOpportunisticUsageKey"
        titleLabel4.text = "volumeTotalCapacityKey"
        titleLabel5.text = "iOS 9/10"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSizes()
    }
    
    @IBAction private func onRefresh(_ sender: UIBarButtonItem) {
        updateSizes()
    }
    
    @IBAction private func onClear(_ sender: UIBarButtonItem) {
        clearCache()
        updateSizes()
    }
    
    @IBAction private func onCreateCash(_ sender: UIBarButtonItem) {
        createCash()
        updateSizes()
    }
    
    private func clearCache() {
        let fileManager = FileManager.default
        guard let documentsUrl =  fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            assertionFailure()
            return
        }
        let documentsPath = documentsUrl.path
        
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
            print("--- all files in cache:\n\(fileNames)")
            
            for fileName in fileNames {
                /// System Error Code=513:
                /// "Snapshots" couldn’t be removed because you don’t have permission to access it.
                guard fileName != "Snapshots" else {
                    return
                }
                let filePathName = "\(documentsPath)/\(fileName)"
                try fileManager.removeItem(atPath: filePathName)
            }
            
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
            print("--- all files in cache after deleting images:\n\(files)")
            
        } catch {
            assertionFailure("Could not clear temp folder: \(error)")
        }

        /// #2
        /// https://stackoverflow.com/a/50122279/5893286
//        let caches = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
//        let appId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
//        let path = String(format:"%@/%@/Cache.db-wal",caches, appId)
//        do {
//            try FileManager.default.removeItem(atPath: path)
//        } catch {
//            print("ERROR DESCRIPTION: \(error)")
//        }
        
    }
    
    private func createCash() {
        guard let temporaryDirectoryURL = try? FileManager.default.url(for: .cachesDirectory,
                                                                   in: .userDomainMask,
                                                                   appropriateFor: nil,
                                                                   create: false)
            else {
                assertionFailure()
                return
        }
        let fileName = ProcessInfo().globallyUniqueString
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(fileName)
        let data = Data(repeating: 1, count: 1024 * 1024 * 100)
        do {
            try data.write(to: temporaryFileURL, options: .atomicWrite)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        print("ready")
    }

    private func updateSizes() {
        /// volumeAvailableCapacityKey - доступное место, тоже самое что файловый менеджер отдаст.
        /// volumeAvailableCapacityForImportantUsageKey - всё свободное, с учётом возможности удаления кэша, временных файлов и т.д.
        /// В случае с volumeAvailableCapacityForImportantUsageKey нас не  пускает система в “защищенное” пространство
        // TODO: check vs .volumeAvailableCapacityKey, .volumeAvailableCapacityForOpportunisticUsageKey
        
        let fileURL = URL(fileURLWithPath: Device.homeFolder)
//        let fileURL = URL(fileURLWithPath: "/")
//        let fileURL = URL(fileURLWithPath: NSHomeDirectory())
        
        
        
        if #available(iOS 11.0, *) {

            let mb: Double = 1024
//            let mb: Double = 1000
            
            
            
            let values1 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityKey])
            let size1 = Int64(values1?.volumeAvailableCapacity ?? 0)
            sizeLabel1.text = "\(size1)\n\(Double(size1)/mb/mb/mb)"
            
            
            /// not working with fileURL "URL(fileURLWithPath: "/")"
            let values2 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            let size2 = Int64(values2?.volumeAvailableCapacityForImportantUsage ?? 0)
            sizeLabel2.text = "\(size2)\n\(Double(size2)/mb/mb/mb)"
            
            
            /// not working with fileURL "URL(fileURLWithPath: "/")"
            let values3 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey])
            let size3 = Int64(values3?.volumeAvailableCapacityForOpportunisticUsage ?? 0)
            sizeLabel3.text = "\(size3)\n\(Double(size3)/mb/mb/mb)"
            
            let values4 = try? fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
            let size4 = Int64(values4?.volumeTotalCapacity ?? 0)
            sizeLabel4.text = "\(size4)\n\(Double(size4)/mb/mb/mb)"
            
            sizeLabel1.text! += "\n\(Double(size4 - size1)/mb/mb/mb)"
            sizeLabel2.text! += "\n\(Double(size4 - size2)/mb/mb/mb)"
            sizeLabel3.text! += "\n\(Double(size4 - size3)/mb/mb/mb)"
        }
        
//        if #available(iOS 11.0, *) {
//            let fileURL = URL(fileURLWithPath: Device.homeFolder)
//
//            //let mb: Double = 1024
//            let mb: Double = 1000
//
//
//
//            let values1 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityKey])
//            let size1 = Int64(values1?.volumeAvailableCapacity ?? 0)
//            sizeLabel1.text! += "\n\(size1)\n\(Double(size1)/mb/mb/mb)"
//
//
//            /// Failed to get available space for volume /: Error Domain=CacheDeleteErrorDomain Code=10 "(null)" UserInfo={Volume=/}
//            //            let values2 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
//            //            sizeLabel2.text = String(Int64(values2?.volumeAvailableCapacityForImportantUsage ?? 0))
//            //
//            //            let values3 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey])
//            //            sizeLabel3.text = String(Int64(values3?.volumeAvailableCapacityForOpportunisticUsage ?? 0))
//
//            let values4 = try? fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
//            let size4 = Int64(values4?.volumeTotalCapacity ?? 0)
//            sizeLabel4.text! += "\n\n\(size4)\n\(Double(size4)/mb/mb/mb)"
//            sizeLabel4.text! +=  "\n\(Double(size4 - size1)/mb/mb/mb)"
//        }
        
        /// iOS 9
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: Device.homeFolder)
        let freeSize = systemAttributes?[.systemFreeSize] as? NSNumber
        
        let newFreeSize = freeSize?.int64Value ?? 0
        print("--- size:", self.freeSize - newFreeSize)
        self.freeSize = newFreeSize
        sizeLabel5.text = String(self.freeSize)
    }
    
    var freeSize: Int64 = 0
}


typealias AllVolumeStorageCapacity = (totalDiskSpace: Int64, freeDiskSpace: Int64, usedDiskSpace: Int64)

protocol VolumeStorageCapacityProtocol {
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity
    func totalDiskSpace() -> Int64
    func freeDiskSpace() -> Int64
    func usedDiskSpace() -> Int64
}

final class VolumeStorageCapacityAny: VolumeStorageCapacityProtocol {
    private let volumeStorageCapacity: VolumeStorageCapacityProtocol
    
    init() {
        if #available(iOS 11.0, *) {
            volumeStorageCapacity = VolumeStorageCapacityFromiOS11()
        } else {
            volumeStorageCapacity = VolumeStorageCapacityOld()
        }
    }
    
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity {
        return volumeStorageCapacity.allVolumeStorageCapacity()
    }
    
    func totalDiskSpace() -> Int64 {
        return volumeStorageCapacity.totalDiskSpace()
    }
    
    func freeDiskSpace() -> Int64 {
        return volumeStorageCapacity.freeDiskSpace()
    }
    
    func usedDiskSpace() -> Int64 {
        return volumeStorageCapacity.usedDiskSpace()
    }
}

final class VolumeStorageCapacityOld: VolumeStorageCapacityProtocol {
    
    private let homeDir = NSHomeDirectory()
    
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity {
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
        
        let totalSpace = systemAttributes?[.systemSize] as? NSNumber
        let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
        
        let totalSpaceSize = totalSpace?.int64Value ?? 0
        let freeSpaceSize = freeSpace?.int64Value ?? 0
        
        return (totalDiskSpace: totalSpaceSize,
                freeDiskSpace: freeSpaceSize,
                usedDiskSpace: totalSpaceSize - freeSpaceSize)
    }
    
    func totalDiskSpace() -> Int64 {
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
        let totalSpace = systemAttributes?[.systemSize] as? NSNumber
        return totalSpace?.int64Value ?? 0
    }
    
    func freeDiskSpace() -> Int64 {
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
        let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
        return freeSpace?.int64Value ?? 0
    }
    
    func usedDiskSpace() -> Int64 {
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
        
        let totalSpace = systemAttributes?[.systemSize] as? NSNumber
        let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
        
        let totalSpaceSize = totalSpace?.int64Value ?? 0
        let freeSpaceSize = freeSpace?.int64Value ?? 0
        
        return totalSpaceSize - freeSpaceSize
    }
}

@available(iOS 11.0, *)
final class VolumeStorageCapacityFromiOS11: VolumeStorageCapacityProtocol {
    
    private let homeURL = URL(fileURLWithPath: NSHomeDirectory())
    
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity {
        let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                           .volumeTotalCapacityKey])
        let totalSpaceSize = Int64(values?.volumeTotalCapacity ?? 0)
        let freeSpaceSize = values?.volumeAvailableCapacityForImportantUsage ?? 0
        
        return (totalDiskSpace: totalSpaceSize,
                freeDiskSpace: freeSpaceSize,
                usedDiskSpace: totalSpaceSize - freeSpaceSize)
    }
    
    func totalDiskSpace() -> Int64 {
        let values = try? homeURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
        return Int64(values?.volumeTotalCapacity ?? 0)
    }
    
    /// like system one
    func freeDiskSpace() -> Int64 {
        let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
        return Int64(values?.volumeAvailableCapacityForImportantUsage ?? 0)
    }
    
    func usedDiskSpace() -> Int64 {
        let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                           .volumeTotalCapacityKey])
        let totalSpaceSize = Int64(values?.volumeTotalCapacity ?? 0)
        let freeSpaceSize = values?.volumeAvailableCapacityForImportantUsage ?? 0
        
        return totalSpaceSize - freeSpaceSize
    }
}

//    func MBFormatter(_ bytes: Int64) -> String {
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = ByteCountFormatter.Units.useMB
//        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
//        formatter.includesUnit = false
//        return formatter.string(fromByteCount: bytes) as String
//    }
//
//    //MARK: Get String Value
//    var totalDiskSpaceInGB:String {
//        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes(), countStyle: ByteCountFormatter.CountStyle.decimal)
//    }
//
//    var freeDiskSpaceInGB:String {
//        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
//    }
//
//    var usedDiskSpaceInGB:String {
//        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
//    }
//
//    var totalDiskSpaceInMB:String {
//        return MBFormatter(totalDiskSpaceInBytes)
//    }
//
//    var freeDiskSpaceInMB:String {
//        return MBFormatter(freeDiskSpaceInBytes)
//    }
//
//    var usedDiskSpaceInMB:String {
//        return MBFormatter(usedDiskSpaceInBytes)
//    }

/// https://stackoverflow.com/a/47463829/5893286
/// https://developer.apple.com/documentation/foundation/urlresourcekey/checking_volume_storage_capacity
final class VolumeStorageCapacity: VolumeStorageCapacityProtocol {
    
    /// need only for iOS <= 10
    private let homeDir: String
    
    /// need only for iOS 11
    private let homeURL: URL
    
    init() {
        homeDir = NSHomeDirectory()
        homeURL = URL(fileURLWithPath: homeDir)
    }
    
    func totalDiskSpace() -> Int64 {
        if #available(iOS 11.0, *) {
            let values = try? homeURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
            return Int64(values?.volumeTotalCapacity ?? 0)
        } else {
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
            let totalSpace = systemAttributes?[.systemSize] as? NSNumber
            return totalSpace?.int64Value ?? 0
        }
    }
    
    /// like system one
    func freeDiskSpace() -> Int64 {
        if #available(iOS 11.0, *) {
            let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            return Int64(values?.volumeAvailableCapacityForImportantUsage ?? 0)
        } else {
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
            let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
            return freeSpace?.int64Value ?? 0
        }
    }
    
    /// optmized version. not totalDiskSpace() - freeDiskSpace()
    func usedDiskSpace() -> Int64 {
        if #available(iOS 11.0, *) {
            let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                               .volumeTotalCapacityKey])
            let freeSpaceSize = values?.volumeAvailableCapacityForImportantUsage ?? 0
            let totalSpaceSize = Int64(values?.volumeTotalCapacity ?? 0)
            return totalSpaceSize - freeSpaceSize
        } else {
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
            
            let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
            let totalSpace = systemAttributes?[.systemSize] as? NSNumber
            
            let freeSpaceSize = freeSpace?.int64Value ?? 0
            let totalSpaceSize = totalSpace?.int64Value ?? 0
            
            return totalSpaceSize - freeSpaceSize
        }
    }
    
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity {
        if #available(iOS 11.0, *) {
            let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                               .volumeTotalCapacityKey])
            let totalSpaceSize = Int64(values?.volumeTotalCapacity ?? 0)
            let freeSpaceSize = values?.volumeAvailableCapacityForImportantUsage ?? 0
            let usedSpaseSize = totalSpaceSize - freeSpaceSize
            
            return (totalDiskSpace: totalSpaceSize,
                    freeDiskSpace: freeSpaceSize,
                    usedDiskSpace: usedSpaseSize)
        } else {
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
            
            let totalSpace = systemAttributes?[.systemSize] as? NSNumber
            let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
            
            let totalSpaceSize = totalSpace?.int64Value ?? 0
            let freeSpaceSize = freeSpace?.int64Value ?? 0
            
            let usedSpaseSize = totalSpaceSize - freeSpaceSize
            
            return (totalDiskSpace: totalSpaceSize,
                    freeDiskSpace: freeSpaceSize,
                    usedDiskSpace: usedSpaseSize)
        }
    }
}

//iOSComponents

/// for disk space
/// https://stackoverflow.com/questions/26198073/query-available-ios-disk-space-with-swift
final class Device {
    
    static var homeFolder: String {
        return NSHomeDirectory() as String
//                return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
    }
    
    /// Available vs Free
    ///
    /// iOS 10
    /// iTunes: 10.57
    /// iPhone settings 8.27
    /// current var: 7.52
    ///
    /// iOS 9
    /// iTunes: 4.79
    /// iPhone settings 3.9
    /// current var: 4.13
    static var freeDiskSpace: Int64 {
        if #available(iOS 11.0, *) {
            let fileURL = URL(fileURLWithPath: homeFolder)
            /// volumeAvailableCapacityKey - доступное место, тоже самое что файловый менеджер отдаст.
            /// volumeAvailableCapacityForImportantUsageKey - всё свободное, с учётом возможности удаления кэша, временных файлов и т.д.
            /// В случае с volumeAvailableCapacityForImportantUsageKey нас не  пускает система в “защищенное” пространство
            // TODO: check vs .volumeAvailableCapacityKey, .volumeAvailableCapacityForOpportunisticUsageKey
            let values = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityKey])
            return Int64(values?.volumeAvailableCapacity ?? 0)
        } else {
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeFolder)
            let freeSize = systemAttributes?[.systemFreeSize] as? NSNumber
            return freeSize?.int64Value ?? 0
        }
    }
    
    // TODO: need to compare with current method
    //    func getFreeDiskspace() {
    //        var totalSpace: UInt64 = 0
    //        var totalFreeSpace: UInt64 = 0
    //        var error: Error? = nil
    //        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    //        let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last ?? "")
    //
    //        if (dictionary != nil) {
    //            var fileSystemSizeInBytes = dictionary?[.systemSize] as? NSNumber
    //            var freeFileSystemSizeInBytes = dictionary?[.systemFreeSize] as? NSNumber
    //            totalSpace = UInt64(fileSystemSizeInBytes ?? 0)
    //            totalFreeSpace = UInt64(freeFileSystemSizeInBytes ?? 0)
    //            //            CS_Log_Info("Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace / 1024) / 1024), ((totalFreeSpace / 1024) / 1024))
    //        } else {
    //            //            CS_Log_Info("Error Obtaining System Memory Info: Domain = %@, Code = %ld", (error as NSError?)?.domain, Int(error.code))
    //        }
    //        let totalSpace1 = (totalSpace / 1024) / 1024
    //        let totalFreeSpace2 = (totalFreeSpace / 1024) / 1024
    //    }
    
    
    
    static var totalDiskSpace: Int64 {
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeFolder)
        let totalSpace = systemAttributes?[.systemSize] as? NSNumber
        return totalSpace?.int64Value ?? 0
    }
    
    static var usedDiskSpace: Int64 {
        return totalDiskSpace - freeDiskSpace
    }
}
