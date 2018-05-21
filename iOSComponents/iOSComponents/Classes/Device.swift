//
//  Device.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/14/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

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
