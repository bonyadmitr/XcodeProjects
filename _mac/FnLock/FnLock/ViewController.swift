//
//  ViewController.swift
//  FnLock
//
//  Created by Bondar Yaroslav on 8/20/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        FnLock.shared.changeSetting(setting: true)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

/// not working in sandbox
final class FnLock {
    
    static let shared = FnLock()
    
    private let service: io_service_t
    
    init() {
        let classToMatch = IOServiceMatching(kIOHIDSystemClass)
        service = IOServiceGetMatchingService(kIOMasterPortDefault, classToMatch)
    }
    
    func changeSetting(setting: Bool) {
        var enabled = setting ? UInt32(0) : UInt32(1)
        
        var connect: io_connect_t = 0
        
        guard IOServiceOpen(service, mach_task_self_, UInt32(kIOHIDParamConnectType), &connect).asseredSuccess() else {
            return
        }
        
        /// failed in sandbox here
        guard IOHIDSetParameter(connect, kIOHIDFKeyModeKey as CFString, &enabled, 1) == kIOReturnSuccess else {
            return
        }
        
        guard IOServiceClose(connect) == kIOReturnSuccess else {
            return
        }
    }
    
    func getSetting() -> Bool? {
        var connect: io_connect_t = 0
        
        guard IOServiceOpen(service, mach_task_self_, UInt32(kIOHIDParamConnectType), &connect).asseredSuccess() else {
            return nil
        }
        
        var value = UInt32(0)
        var actualSize = UInt32(0)
        
        guard IOHIDGetParameter(connect, kIOHIDFKeyModeKey as CFString, 1, &value, &actualSize).asseredSuccess() else {
            return nil
        }
        
        guard IOServiceClose(connect).asseredSuccess() else {
            return nil
        }
        
        return value == 0
    }
    
    func saveState() {
        CFPreferencesSetAppValue("fnState" as CFString, kCFBooleanFalse, "com.apple.keyboard" as CFString)
        CFPreferencesAppSynchronize("com.apple.keyboard" as CFString)
        CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFNotificationName.init(rawValue: "com.apple.keyboard.fnstatedidchange" as CFString), nil, nil, true)
    }
}

extension kern_return_t {
    func handleError() {
        assert(self == kIOReturnSuccess, "reason: \(self)")
    }
    
    func asseredSuccess() -> Bool {
        assert(self == kIOReturnSuccess, "reason: \(self)")
        return self == kIOReturnSuccess
    }
}
