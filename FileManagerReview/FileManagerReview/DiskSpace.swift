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
    
    func percents(for spaceType: SpaceType) -> (double: Double, int: Int) {
        let percent = percent(for: spaceType)
        return (double: percent, int: Int(percent: percent))
    }
    
    func percentInt(for spaceType: SpaceType) -> Int {
        let percent = percent(for: spaceType)
        return Int(percent: percent)
    }
    
    func percent(for spaceType: SpaceType) -> Double {
        let total = Double(total)
        let spaceTypeValue: Double
        
        switch spaceType {
        case .free:
            spaceTypeValue = Double(free)
        case .used:
            spaceTypeValue = Double(used)
        case .total:
            assertionFailure("we never need total")
            return 100
        }
        return spaceTypeValue / total
    }

}

extension DiskSpace {
    
    enum DiskStatusType {
        case normal
        case warning
        case critical
    }
    
    func diskStatusType() -> DiskStatusType {
        let freeDiskSpaceInMB = free / 1024 / 1024
        
        if freeDiskSpaceInMB <= 70 {
            return .critical
        } else if freeDiskSpaceInMB <= 250 {
            return .warning
        } else {
            return .normal
        }
    }
    
    // TODO: test
    static func shouldShowDiskStatusAlert() -> Bool {
        let diskSpace = now()
        
        let shouldShow: Bool

        switch diskSpace.diskStatusType() {
        case .normal:
            shouldShow = false
        case .warning:
            if let lastShown = UserDefaults.standard.value(forKey: "shouldShowDiskStatusPopup") as? Date {
                // TODO: check Date(timeIntervalSinceNow: lastShown.timeIntervalSince1970)
                let diff = Date() - lastShown.timeIntervalSince1970
                let day = NSCalendar.current.component(.day, from: diff)
                shouldShow = day > 0
            } else {
                UserDefaults.standard.set(Date(), forKey: "shouldShowDiskStatusPopup")
                shouldShow = true
            }
        case .critical:
            shouldShow = true
        }

        return shouldShow
    }
}






enum Formatters {
    
    /// apple source https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/ByteCountFormatter.swift
    private static let storageFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        
        /// defailt `[]`: uses platform-appropriate settings
        //formatter.allowedUnits = []
        
        /// drop units like`MB or GB`
        //formatter.includesUnit = false
        
        /// doc: display of file or storage byte counts. may change over time
        /// `.decimal` - like system values
        formatter.countStyle = .file
        
        /// disable `0` as `Zero KB`
        formatter.allowsNonnumericFormatting = false
        
        /// false - more 100 GB is rounded, in iOS system: `18,3 GB of 128 GB`
        /// default true: `18,35 GB of 127,87 GB`, in macOS system `499.96 GB`
        formatter.isAdaptive = false
        
        return formatter
    }()
    
    
    /// test code:
    //let mb: Int64 = 1000 * 1000
    //let gb: Int64 = mb * 1000
    //let volumes: [Int64] = [
    //    128 * gb,
    //    128 * gb - 500 * mb,
    //    101 * gb - 500 * mb,
    //    100 * gb - 500 * mb,
    //    20 * gb - 500 * mb,
    //    700 * mb,
    //    1024,
    //]
    //print( volumes.map { fileSize(from: $0) } )
    ///
    /// more 100 GB is rounded, like system `formatter.isAdaptive = false`
    /// ["128 GB", "128 GB", "101 GB", "99.5 GB", "19.5 GB", "700 MB", "1.02 KB"]
    ///
    /// default `formatter.isAdaptive = true`
    /// ["128 GB", "127.5 GB", "100.5 GB", "99.5 GB", "19.5 GB", "700 MB", "1 KB"]
    ///
    static func fileSize(from bytes: Int64) -> String {
#if targetEnvironment(macCatalyst)
        /// like macOS system sizes
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
#else
        storageFormatter.string(fromByteCount: bytes)
#endif
    }
}


extension DiskSpace {
    
    // TODO: think, add to SpaceType
    /// macOS purgeable disk size
    //https://apple.stackexchange.com/a/394660/407549
    //https://stackoverflow.com/a/55810703/5893286
    //https://www.cleverfiles.com/howto/purgeable-space-mac.html
    /// `0` for iOS simulator bcz `volumeAvailableCapacity == volumeAvailableCapacityForImportantUsage`
    /// for macOS(my: 3,79 GB) and iOS (my: 1,28 GB)
    static func purgeableSize() -> Int64 {
        let rootPath = NSHomeDirectory()
        let rootURL = URL(fileURLWithPath: rootPath, isDirectory: true)
        
        func format(_ bytes: Int64) -> String {
            ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
        }
        
        do {
            let resourceValues = try rootURL.resourceValues(forKeys: [.volumeAvailableCapacityKey, .volumeAvailableCapacityForImportantUsageKey, .volumeAvailableCapacityForOpportunisticUsageKey, .volumeTotalCapacityKey])
            let volumeAvailableCapacity = Int64(resourceValues.volumeAvailableCapacity ?? 0)
            let volumeAvailableCapacityForImportantUsage = resourceValues.volumeAvailableCapacityForImportantUsage ?? 0
            return volumeAvailableCapacityForImportantUsage - volumeAvailableCapacity
        } catch {
            assertionFailure(error.debugDescription)
            return 0
        }
    }
    
}





extension DiskSpace {
    
    static func testDiskSpace() {
        
        let rootPath = NSHomeDirectory()
        
        /// iOS 15, device,`0` for volumeAvailableCapacityForImportantUsageKey, volumeAvailableCapacityForOpportunisticUsageKey
        //let rootPath = "/"
        
        /// directory of the user’s system `"/"`
        //let rootPath = NSOpenStepRootDirectory()
        
        let rootURL = URL(fileURLWithPath: rootPath, isDirectory: true)
        
        func format(_ bytes: Int64) -> String {
            ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
        }
        
        do {
            let resourceValues = try rootURL.resourceValues(forKeys: [.volumeAvailableCapacityKey, .volumeAvailableCapacityForImportantUsageKey, .volumeAvailableCapacityForOpportunisticUsageKey, .volumeTotalCapacityKey])
            
            let volumeAvailableCapacity = Int64(resourceValues.volumeAvailableCapacity ?? 0)
            print("AvailableCapacity: \(volumeAvailableCapacity), \(format(volumeAvailableCapacity))")
            
            let volumeAvailableCapacityForImportantUsage = resourceValues.volumeAvailableCapacityForImportantUsage ?? 0
            print("Available capacity for important usage: \(volumeAvailableCapacityForImportantUsage), \(format(volumeAvailableCapacityForImportantUsage))")
            
            let volumeAvailableCapacityForOpportunisticUsage = resourceValues.volumeAvailableCapacityForOpportunisticUsage ?? 0
            print("AvailableCapacityForOpportunistic: \(volumeAvailableCapacityForOpportunisticUsage), \(format(volumeAvailableCapacityForOpportunisticUsage))")
            
            let volumeTotalCapacity = Int64(resourceValues.volumeTotalCapacity ?? 0)
            print("total: \(volumeTotalCapacity), \(format(Int64(volumeTotalCapacity)))")
            
            let purgeableSize = volumeAvailableCapacityForImportantUsage - volumeAvailableCapacity
            print("purgeable size: \(purgeableSize), \(format(purgeableSize))")
            
            let nonessentialSize = volumeAvailableCapacityForImportantUsage - volumeAvailableCapacityForOpportunisticUsage
            print("nonessential difference size: \(nonessentialSize), \(format(nonessentialSize))")
            
            print()
            
#if targetEnvironment(macCatalyst)
            assert(volumeAvailableCapacityForImportantUsage > volumeAvailableCapacity)
            assert(volumeAvailableCapacity > volumeAvailableCapacityForOpportunisticUsage)

#elseif targetEnvironment(simulator)
            assert(volumeAvailableCapacity == volumeAvailableCapacityForImportantUsage)
            assert(volumeAvailableCapacity == volumeAvailableCapacityForOpportunisticUsage)
#elseif os(iOS)
            assert(volumeAvailableCapacityForImportantUsage > volumeAvailableCapacity)
            assert(volumeAvailableCapacity > volumeAvailableCapacityForOpportunisticUsage)

#else /// tvOS
            assertionFailure()
#endif
            
            /// do not breakpoint here bcz `.systemFreeSize` can be changed and `assert(volumeAvailableCapacity == freeSpace)` will fail
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: rootPath),
               let freeSpace = systemAttributes[.systemFreeSize] as? Int64,
               let totalSpace = systemAttributes[.systemSize] as? Int64
            {
                assert(volumeAvailableCapacity == freeSpace)
                assert(volumeTotalCapacity == totalSpace)
            } else {
                assertionFailure("")
            }
            
        } catch {
            assertionFailure(error.debugDescription)
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

func humanReadableByteCount(bytes: Int) -> String {
    if (bytes < 1000) { return "\(bytes) B" }
    let exp = Int(log2(Double(bytes)) / log2(1000.0))
    let unit = ["KB", "MB", "GB", "TB", "PB", "EB"][exp - 1]
    let number = Double(bytes) / pow(1000, Double(exp))
    return String(format: "%.1f %@", number, unit)
}
