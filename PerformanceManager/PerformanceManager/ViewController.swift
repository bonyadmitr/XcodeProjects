//
//  ViewController.swift
//  PerformanceManager
//
//  Created by Bondar Yaroslav on 5/22/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: window
// https://github.com/dani-gavrilov/GDPerformanceView-Swift/blob/master/GDPerformanceView-Swift/GDPerformanceMonitoring/PerformanceView.swift

final class ViewController: UIViewController {

    private let performanceManager = PerformanceManager()
    
    private let bytesInMegabyte = 1024.0 * 1024.0
    private lazy var totalMemory = Double(performanceManager.memoryTotal) / bytesInMegabyte
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        performanceManager.deleagte = self
        performanceManager.start()
    }
    
    deinit {
        print("deinit ViewController")
        performanceManager.stop()
    }
}

extension ViewController: PerformanceManagerDelegate {
    func performanceManager(_ performanceManager: PerformanceManager, didTickFPS framesPerSecond: Double) {
        
        print()
        print(String(format: "FPS: %.1f%", framesPerSecond))
        print(String(format: "CPU: %.1f%%", performanceManager.appCpuUsage()))
        
        let usedMemory = Double(performanceManager.appMemoryUsage()) / bytesInMegabyte
        let memory = String(format: "%.1f of %.0f MB used", usedMemory, totalMemory)
        print(memory)
    }
}
