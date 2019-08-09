import Foundation
import AppKit.NSWorkspace

final class SystemWindowsManager {
    
    /// https://stackoverflow.com/a/30337008/5893286
    static func windowsInfo() -> [[String : Any]] {
        return CGWindowListCopyWindowInfo(.optionAll, kCGNullWindowID) as? [[String: Any]] ?? []
    }
    
    static func visibleWindowsImages() -> [CGImage] {
        return windowsInfo()
            .filter {
                if let boundsDict = $0[kCGWindowBounds as String] as? [String: Int],
                    let height = boundsDict["Height"]
                {
                    /// 40 is magic number to filter small windows like App Menu (Height = 22)
                    return height > 40
                }
                return false
            }.compactMap {
                $0[kCGWindowNumber as String] as? CGWindowID
            }.compactMap {
                CGWindowListCreateImage(.null,
                                        .optionIncludingWindow,
                                        $0,
                                        [.boundsIgnoreFraming,
                                         //.shouldBeOpaque,
                                            .nominalResolution])
        }
    }
    
    static func compositedWindowsByName() -> [String: CGImage] {
        return Dictionary(grouping: windowsInfo()) {
            return $0[kCGWindowOwnerName as String] as? String ?? "unknown"
            }.compactMapValues { infoArray -> [UInt] in
                infoArray.compactMap { $0[kCGWindowNumber as String] as? UInt }
            }.compactMapValues { windowIds -> CGImage? in
                CGImage(windowListFromArrayScreenBounds: .null,
                        windowArray: cfarray(from: windowIds),
                        imageOption: [.boundsIgnoreFraming, .nominalResolution])
        }
    }
    
    static func windowsByName() -> [String: [CGImage]] {
        let systemWindows = ["Notification Center", "TISwitcher", "Legacy Color Picker Extensions", "Dock", "Window Server", ]
        
        let windowsInfo = self.windowsInfo()
            .filter { /// filter system windows
                if let appName = $0[kCGWindowOwnerName as String] as? String {
                    return !systemWindows.contains(appName)
                }
                return true
            }.filter { /// filter small windows
                if let boundsDict = $0[kCGWindowBounds as String] as? [String: Int],
                    let height = boundsDict["Height"]
                {
                    /// 22 is App Menu height
                    // TODO: need to check on other resolution
                    // TODO: https://stackoverflow.com/a/30311638/5893286
                    return height > 22
                }
                return false
        }
        return Dictionary(grouping: windowsInfo) {
            return $0[kCGWindowOwnerName as String] as? String ?? "unknown"
            }.compactMapValues { infoArray -> [UInt] in
                infoArray.compactMap { $0[kCGWindowNumber as String] as? UInt }
            }.compactMapValues { windowIds -> [CGImage] in
                windowIds
                    .compactMap {
                        cfarray(from: [$0])
                    }.compactMap {
                        CGImage(windowListFromArrayScreenBounds: .null,
                                windowArray: $0,
                                imageOption: [.boundsIgnoreFraming, .nominalResolution])
                }
        }
    }
    
    static func compositedWindow(for appName: String) -> CGImage? {
        let windowIds = windowsInfo()
            .filter { $0[kCGWindowOwnerName as String] as? String == appName }
            .compactMap { $0[kCGWindowNumber as String] as? UInt }
        
        return CGImage(windowListFromArrayScreenBounds: .null,
                       windowArray: cfarray(from: windowIds),
                       imageOption: [.boundsIgnoreFraming, .nominalResolution])
    }
    
    /// https://stackoverflow.com/a/46652374/5893286
    static private func cfarray(from array: [UInt]) -> CFArray {
        let pointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: array.count)
        for (index, item) in array.enumerated() {
            pointer[index] = UnsafeRawPointer(bitPattern: item)
        }
        return CFArrayCreate(kCFAllocatorDefault, pointer, array.count, nil)
    }
    
    /// at https://stackoverflow.com/a/8657973/5893286 said that it isn't possible, but i got it
    /// filter small windows
    static func getHiddenWindowsImages() -> [CGImage] {
        return windowsInfo()
            .filter {
                if let boundsDict = $0[kCGWindowBounds as String] as? [String: Int],
                    let height = boundsDict["Height"]
                {
                    /// 40 is magic number to filter small windows like App Menu (Height = 22)
                    return height > 40
                }
                return false
            }.compactMap {
                $0[kCGWindowNumber as String] as? UInt
            }.compactMap { id -> CFArray in
                ///reused code: cfarray(from: [id])
                let pointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
                pointer.pointee = UnsafeRawPointer(bitPattern: id)
                return CFArrayCreate(kCFAllocatorDefault, pointer, 1, nil)
            }.compactMap {
                CGImage(windowListFromArrayScreenBounds: .null, windowArray: $0,
                        imageOption: [.boundsIgnoreFraming, .nominalResolution])
        }
        
    }
    
    static func compositedWindowForBundleId(_ bundleId: String) -> CGImage? {
        let processId = processIdentifier(for: bundleId)
        let windowIds = windowsInfo()
            .filter { $0[kCGWindowOwnerPID as String] as? Int32 == processId }
            .compactMap { $0[kCGWindowNumber as String] as? UInt }
        
        return CGImage(windowListFromArrayScreenBounds: .null,
                       windowArray: cfarray(from: windowIds),
                       imageOption: [.boundsIgnoreFraming, .nominalResolution])
    }
    
    static func processIdentifier(for bundleId: String) -> pid_t? {
        /// caseInsensitiveCompare need for: "com.google.chrome" vs "com.google.Chrome"
        return NSWorkspace.shared.runningApplications
            .first { $0.bundleIdentifier?.caseInsensitiveCompare(bundleId) == .orderedSame }?.processIdentifier
    }
}
