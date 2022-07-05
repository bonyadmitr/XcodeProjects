//
//  DiskSpace.swift
//  FileManagerReview
//
//  Created by Yaroslav Bondar on 12.11.2021.
//

import Foundation

// TODO: there is DiskSpace project
/// another possible name `VolumeStorage`
struct DiskSpace {
    
    let free: Int64
    let used: Int64
    let total: Int64
    
    private init(free: Int64, used: Int64, total: Int64) {
        self.free = free
        self.used = used
        self.total = total
    }
    
    
    /// iOS 15, device, size =`0` for `.volumeAvailableCapacityForImportantUsageKey` and `.volumeAvailableCapacityForOpportunisticUsageKey`
    /// the same `0` for `.resourceValues(forKeys: [.volumeSupportsVolumeSizesKey]) + .volumeSupportsVolumeSizes`
    //let rootPath = "/"
    private static let rootPath = NSHomeDirectory()
    
    private static let rootURL = URL(fileURLWithPath: rootPath, isDirectory: true)
    
    /// alternative https://stackoverflow.com/a/47463829/5893286
    static func now() -> DiskSpace {
        let freeDiskSpace: Int64
        let totalDiskSpace: Int64
        
        do {
            /// iOS 11 https://developer.apple.com/documentation/foundation/urlresourcekey/checking_volume_storage_capacity
            /// can be used `.volumeAvailableCapacityKey, .volumeAvailableCapacityForOpportunisticUsageKey` for iOS in other places
            /// `.volumeAvailableCapacityForImportantUsageKey` is biggest in the iOS
            /// `.volumeAvailableCapacityForImportantUsageKey` = macOS Finder's "available"
            /// all 3 `.volumeAvailable...Key` values are the same in the iOS simulator
            ///
            /// `.resourceValues(forKeys` prefered bcz of cache
            /// can be optimized manually to get `.volumeTotalCapacity` 1 time, it will not be changed
            let resourceValues = try rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])
            freeDiskSpace = resourceValues.volumeAvailableCapacityForImportantUsage ?? 0
            totalDiskSpace = Int64(resourceValues.volumeTotalCapacity ?? 0)
            
        } catch {
            assertionFailure(error.debugDescription)
            
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: rootPath),
               let freeSpace = systemAttributes[.systemFreeSize] as? Int64,
               let totalSpace = systemAttributes[.systemSize] as? Int64
            {
                freeDiskSpace = freeSpace
                totalDiskSpace = totalSpace
            } else {
                freeDiskSpace = 0
                totalDiskSpace = 0
                assertionFailure(error.debugDescription)
            }
        }
        
        let usedDiskSpace = totalDiskSpace - freeDiskSpace
        
        return DiskSpace(free: freeDiskSpace, used: usedDiskSpace, total: totalDiskSpace)
    }
    
}

// MARK: - DiskSpace formatted

extension DiskSpace {
    
    enum SpaceType {
        case free
        case used
        case total
    }
    
    private static var totalformatted = ""
    
    func formatted(for spaceType: SpaceType) -> String {
        switch spaceType {
        case .free:
            return Formatters.fileSize(from: free)
        case .used:
            return Formatters.fileSize(from: used)
        case .total:
            /// optimized to format `total` 1 time. it will not be changed
            guard Self.totalformatted.isEmpty else {
                return Self.totalformatted
            }
            let total = Formatters.fileSize(from: total)
            Self.totalformatted = total
            return total
        }
    }
    

}
extension Int {
    init(percent value: Double, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) {
        self.init((value * 100).rounded(rule))
    }
}

extension Double {
    
    /// Rounds the double to decimal places value
    /// inspired https://stackoverflow.com/a/32581409/5893286
    func roundedDecimalPlaces(to places: Int) -> Double {
        /// instead of `round((value * 100.0)) / 100.0`
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}

