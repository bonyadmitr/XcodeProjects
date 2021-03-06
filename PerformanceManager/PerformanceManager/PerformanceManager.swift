import Foundation
import QuartzCore.CADisplayLink

protocol PerformanceManagerDelegate: class {
    func performanceManager(_ performanceManager: PerformanceManager, didTickFPS framesPerSecond: Double)
}

// TODO: add guard var isStarted

// TODO: check for background
//DispatchQueue.global().async {
//    self.displaylink = CADisplayLink(target: self, selector: #selector(self.linkTriggered))
//    self.displaylink.add(to: .current, forMode: .default)
//    RunLoop.current.run()
//}

/// for 120fps add CADisableMinimumFrameDuration YES in Info.plist
/// https://developer.apple.com/library/archive/technotes/tn2460/_index.html
///
/// don't fogget to call func stop() in owner deinit
final class PerformanceManager {
    
    weak var deleagte: PerformanceManagerDelegate?
    
    /// can be static
    let memoryTotal = ProcessInfo.processInfo.physicalMemory
    
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    
    /// can be used in init, not in start()
    /// displayLink.isPaused = true
    func start() {
        lastTimestamp = 0
        let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick))
        displayLink.add(to: .current, forMode: .default)
        self.displayLink = displayLink
        
        /// https://dmtopolog.com/cadisplaylink-and-its-applications/
        ///
        /// displayLink.duration will not change for preferredFramesPerSecond less then maximum for your device
        /// with default preferredFramesPerSecond displayLink.duration = displayLink.targetTimestamp - displayLink.timestamp = 0.166 for 60 fps
        ///
        //if #available(iOS 10.3, *) {
        //    print(UIScreen.main.maximumFramesPerSecond)
        //}
        
        //let preferredFramesPerSecond = 30
        //if #available(iOS 10.0, *) {
        //    displayLink.preferredFramesPerSecond = preferredFramesPerSecond
        //} else {
        //    displayLink.frameInterval = preferredFramesPerSecond
        //}
    }
    
    @objc private func displayLinkTick(_ displayLink: CADisplayLink) {
        
        let framesPerSecond: Double
        
        if #available(iOS 10.0, *) {
            /// https://developer.apple.com/documentation/quartzcore/cadisplayLink
            /// displayLink.targetTimestamp - displayLink.timestamp = 0.0166 for 60 fps
            assert(displayLink.targetTimestamp - displayLink.timestamp != 0)
            framesPerSecond = 1 / (displayLink.targetTimestamp - displayLink.timestamp)
            
            /// https://medium.com/@dmitryivanov_54099/cadisplaylink-and-its-applications-bfafb760d738
            /// https://github.com/DmIvanov/Animations/blob/master/Animations/AnimationView.swift
            /// on simulator sometimes assert rises up
            #if DEBUG
            assert(displayLink.targetTimestamp > CACurrentMediaTime(), "took longer than 1 frame")
            if displayLink.targetTimestamp <= CACurrentMediaTime() {
                print("--- took longer than 1 frame")
            }
            #endif
            
        } else {
            
            /// only for first displayLinkTick
            /// https://gist.github.com/ibireme/8398714c741fc2097604
            if lastTimestamp == 0 {
                lastTimestamp = displayLink.timestamp
                return
            }
            
            assert(lastTimestamp != 0)
            assert(displayLink.timestamp - lastTimestamp != 0)
            
            /// will not be called for first displayLinkTick
            framesPerSecond = 1 / (displayLink.timestamp - lastTimestamp)
            
            /// save lastTimestamp for next displayLinkTick after calculation frameNumber
            lastTimestamp = displayLink.timestamp
        }
        
        deleagte?.performanceManager(self, didTickFPS: framesPerSecond)
    }
    
    /// you cannot do this in deinit of PerformanceManager
    /// https://stackoverflow.com/a/47369566/5893286
    func stop() {
        //displayLink.isPaused = true
        displayLink?.invalidate()
    }
    
    /// https://github.com/dani-gavrilov/GDPerformanceView-Swift/blob/master/GDPerformanceView-Swift/GDPerformanceMonitoring/Performance%D0%A1alculator.swift
    /// can be static
    /// app usage, not system
    func appCpuUsage() -> Double {
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
    
    /// app usage, not system
    func appMemoryUsage() -> UInt64 {
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
