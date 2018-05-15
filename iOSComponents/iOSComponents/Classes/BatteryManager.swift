//
//  BatteryManager.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 07/05/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class BatteryManager: NSObject {
    
    static var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    /// disable screen sleep
    /// add in applicationDidBecomeActive
    /// if isCharging {
    ///     UIApplication.shared.isIdleTimerDisabled = true
    /// }
    static var isCharging: Bool {
        return UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
    }
    
    override init() {
        super.init()
        
        /// Register for battery level and state change notifications.
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelChanged), name: .UIDeviceBatteryLevelDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateChanged), name: .UIDeviceBatteryStateDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateBatteryLevel() {
        let batteryLevel = UIDevice.current.batteryLevel
        let batteryLevelString: String
        
        if batteryLevel < 0.0 {
            batteryLevelString = "unknown"
        } else {
            batteryLevelString = String(batteryLevel * 100)
        }
        
        print(batteryLevelString)
    }
    
    private func updateBatteryState() {
        let currentState = UIDevice.current.batteryState
        print(currentState.rawValue) /// need to check
        
//        var batteryState = ""
//        if currentState == .unknown {
//            batteryState = "unknown"
//        } else if currentState == .unplugged {
//            batteryState = "unplugged"
//        } else if currentState == .charging {
//            batteryState = "charging"
//        } else if currentState == .full {
//            batteryState = "full"
//        }
    }
    
    @objc private func batteryLevelChanged(_ notification: Notification) {
        updateBatteryLevel()
    }
    
    @objc private func batteryStateChanged(_ notification: Notification) {
        updateBatteryLevel()
        updateBatteryState()
    }
}
