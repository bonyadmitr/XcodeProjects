//
//  BatteryManager.swift
//  Background
//
//  Created by Bondar Yaroslav on 2/7/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class BatteryManager: NSObject {
    
    static var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    /// connected for charging
    static var isCharging: Bool {
        return UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
    }
    /// disable screen sleep when device is charging
    //if isCharging {
    //    UIApplication.shared.isIdleTimerDisabled = true
    //}
    
    
    override init() {
        super.init()
        
        /// Register for battery level and state change notifications.
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        /// Notifications for battery level change are sent no more frequently than once per minute
        /// https://developer.apple.com/documentation/uikit/uidevice/1620060-batteryleveldidchangenotificatio
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelChanged), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateChanged), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        /// swift 4.1
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
            batteryLevelString = "Unknown"
        } else {
            batteryLevelString = String(batteryLevel * 100)
        }
        
        debugLog("batteryLevelString: \(batteryLevelString)")
    }
    
    private func updateBatteryState() {
        let currentState = UIDevice.current.batteryState
        //        print(currentState.rawValue) /// need to check
        let batteryState: String
        
        switch currentState {
        case .unknown:
            batteryState = "unknown"
        case .unplugged:
            batteryState = "unplugged"
        case .charging:
            batteryState = "charging"
        case .full:
            batteryState = "full"
        }
        
        debugLog("batteryState: \(batteryState)")
    }
    
    @objc private func batteryLevelChanged(_ notification: Notification) {
        debugLog("batteryLevelChanged: \(notification)")
        updateBatteryLevel()
        updateBatteryState()
    }
    
    @objc private func batteryStateChanged(_ notification: Notification) {
        debugLog("batteryStateChanged: \(notification)")
        updateBatteryLevel()
        updateBatteryState()
    }
}
