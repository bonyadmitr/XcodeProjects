//
//  ViewController.swift
//  PerformanceManager
//
//  Created by Bondar Yaroslav on 5/22/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let performanceManager = PerformanceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        performanceManager.start()
    }


}

final class PerformanceManager {
    
    private lazy var displaylink: CADisplayLink = {
        let displaylink = CADisplayLink(target: self, selector: #selector(step))
        displaylink.add(to: .current, forMode: .default)
        //displaylink.isPaused = true
        return displaylink
    }()
    
    func start() {
//        if #available(iOS 10.0, *) {
//            displaylink.preferredFramesPerSecond = 30
//        }
        //displaylink.frameInterval = 30
        displaylink.isPaused = false
    }
    
    @objc private func step(displaylink: CADisplayLink) {
//        print(displaylink.timestamp)
        if #available(iOS 10.0, *) {
            /// https://developer.apple.com/documentation/quartzcore/cadisplaylink
            let actualFramesPerSecond = 1 / (displaylink.targetTimestamp - displaylink.timestamp)
            print(actualFramesPerSecond)
            print(cpuUsage())
            print(memoryUsage() / 1024 / 1024)
            print(memoryTotal() / 1024 / 1024)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func cpuUsage() -> Double {
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
    
    func memoryUsage() -> UInt64 {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.resident_size)
        }
        return used
    }
    
    func memoryTotal() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
}

//import QuartzCore

public typealias MemoryUsage = (used: UInt64, total: UInt64)
