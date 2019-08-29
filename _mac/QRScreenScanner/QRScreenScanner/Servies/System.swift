import Foundation

//#if DEBUG
//if #available(OSX 10.12, *) {
//
//    let bytesInMegabyte = 1024.0 * 1024.0
//    let totalMemory = Double(System.memoryTotal) / bytesInMegabyte
//
//    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
//        let usedMemory = Double(AppInfo.memoryUsage()) / bytesInMegabyte
//        let memory = String(format: "%.1f of %.0f MB used", usedMemory, totalMemory)
//        print(String(format: "CPU: %.1f%%", AppInfo.cpuUsage()))
//        print(memory)
//        print()
//    }
//}
//#endif
enum System {
    
    static let osVersion: String = {
        let os = ProcessInfo.processInfo.operatingSystemVersion
        return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
    }()
    
    /// "MacBookPro11,4" for MacBook Pro 15" Mid-2015
    /// "MacBookPro13,1" for MacBook Pro 13" Late 2016
    static let hardwareModel: String = {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        return String(cString: model)
    }()
    
    /// sysctl machdep.cpu
    /// "machdep.cpu" not working
    /// http://support.moonpoint.com/os/os-x/machdep_cpu.php
    ///
    /// https://stackoverflow.com/a/7379560/5893286
    static let cpuMainInfo: String = {
        var size = 0
        sysctlbyname("machdep.cpu.brand_string", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("machdep.cpu.brand_string", &model, &size, nil, 0)
        return String(cString: model)
    }()
    
    static let memoryTotal = ProcessInfo.processInfo.physicalMemory
    
    /// doc https://developer.apple.com/documentation/coreservices/launch_services
    static func defalutBrowserBundleId() -> String {
        return (LSCopyDefaultHandlerForURLScheme("https" as CFString)?.takeRetainedValue() as String?)
            .assert(or: "")
    }
    
    /// https://stackoverflow.com/a/931277/5893286
    static func allBrowsersBundleIds() -> [String] {
        /// addition "com.apple.Notes", there is no "org.mozilla.firefox"
        //return (LSCopyAllRoleHandlersForContentType(kUTTypeHTML, .viewer)?.takeRetainedValue() as? [String]).assert(or: [])
        /// addition "com.rockysandstudio.MKPlayer"
        return (LSCopyAllHandlersForURLScheme("https" as CFString)?.takeRetainedValue() as? [String]).assert(or: [])
    }
    
    //System.defalutBrowserBundleId()
    //App.id
    static func canOpen(url: URL, by appId: String) -> Bool {
        var errorOutput: Unmanaged<CFError>? = nil
        
        guard
            let appUrls = (LSCopyApplicationURLsForBundleIdentifier(appId as CFString, &errorOutput)?.takeRetainedValue() as? [URL]),
            let appUrl = appUrls.first
        else {
            return false
        }
        
        var canAccept: DarwinBoolean = false
        let result = LSCanURLAcceptURL(url as CFURL, appUrl as CFURL, .viewer, .acceptDefault, &canAccept)
        guard result == noErr else {
            assertionFailure("status: \(result)")
            return false
        }
        if let error = errorOutput?.takeRetainedValue() {
            assertionFailure(error.localizedDescription)
            return false
        }
        return canAccept.boolValue
    }
}

enum AppInfo {
    
    /// app cpu usage
    static func cpuUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList = UnsafeMutablePointer(mutating: [thread_act_t]())
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }
        
        if threadsResult == KERN_SUCCESS {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                
                guard infoResult == KERN_SUCCESS else {
                    break
                }
                
                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }
        
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        return totalUsageOfCPU
    }
    
    /// app memoty usage
    static func memoryUsage() -> UInt64 {
        
        
        // TODO: check on device
        /// memory usage not equal Xcode Debug Gauge
        //        var taskInfo = mach_task_basic_info()
        //        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        //        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
        //            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
        //                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
        //            }
        //        }
        //
        //        var used: UInt64 = 0
        //        if result == KERN_SUCCESS {
        //            used = UInt64(taskInfo.resident_size)
        //        }
        
        /// resident_size does not get accurate memory, and the correct way is to use phys_footprint, which can be proved from the source codes of WebKit and XNU.
        /// https://github.com/WebKit/webkit/blob/master/Source/WTF/wtf/cocoa/MemoryFootprintCocoa.cpp
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }
        
        return used
    }
}
