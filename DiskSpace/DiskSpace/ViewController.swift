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

    
    @IBAction private func refresh(_ sender: UIBarButtonItem) {
        updateSizes()
    }

    func updateSizes() {
        /// volumeAvailableCapacityKey - доступное место, тоже самое что файловый менеджер отдаст.
        /// volumeAvailableCapacityForImportantUsageKey - всё свободное, с учётом возможности удаления кэша, временных файлов и т.д.
        /// В случае с volumeAvailableCapacityForImportantUsageKey нас не  пускает система в “защищенное” пространство
        // TODO: check vs .volumeAvailableCapacityKey, .volumeAvailableCapacityForOpportunisticUsageKey
        let fileURL = URL(fileURLWithPath: Device.homeFolder)
        
        if #available(iOS 11.0, *) {
            let values1 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityKey])
            sizeLabel1.text = String(Int64(values1?.volumeAvailableCapacity ?? 0))
            
            let values2 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            sizeLabel2.text = String(Int64(values2?.volumeAvailableCapacity ?? 0))
            
            let values3 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey])
            sizeLabel3.text = String(Int64(values3?.volumeAvailableCapacity ?? 0))
            
            let values4 = try? fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
            sizeLabel4.text = String(Int64(values4?.volumeAvailableCapacity ?? 0))
        }
        
        /// iOS 9
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: Device.homeFolder)
        let freeSize = systemAttributes?[.systemFreeSize] as? NSNumber
        sizeLabel5.text = String(freeSize?.int64Value ?? 0)
    }
}
//iOSComponents

/// for disk space
/// https://stackoverflow.com/questions/26198073/query-available-ios-disk-space-with-swift
final class Device {
    
    static var homeFolder: String {
        return NSHomeDirectory() as String
        //        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
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
