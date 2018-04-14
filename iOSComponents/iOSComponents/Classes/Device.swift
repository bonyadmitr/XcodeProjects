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
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
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
            ///check vs .volumeAvailableCapacityKey, .volumeAvailableCapacityForOpportunisticUsageKey
            let values = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            return values?.volumeAvailableCapacityForImportantUsage ?? 0
        } else {
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeFolder)
            let freeSize = systemAttributes?[.systemFreeSize] as? NSNumber
            return freeSize?.int64Value ?? 0
        }
    }
    
    static var totalDiskSpace: Int64 {
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeFolder)
        let totalSpace = systemAttributes?[.systemSize] as? NSNumber
        return totalSpace?.int64Value ?? 0
    }
    
    static var usedDiskSpace: Int64 {
        return totalDiskSpace - freeDiskSpace
    }
}
