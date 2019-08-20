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
        
        let q = FnLock.shared.getSetting()
        print(q)
        FnLock.shared.changeSetting(setting: !q)
        print(FnLock.shared.getSetting())
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
        IOServiceConfig { connect in
            IOHIDSetParameter(connect, kIOHIDFKeyModeKey as CFString, &enabled, 1).handleError()
        }
    }
    
    func getSetting() -> Bool {
        var value = UInt32(0)
        var actualSize = UInt32(0)
        
        IOServiceConfig { connect in
            IOHIDGetParameter(connect, kIOHIDFKeyModeKey as CFString, 1, &value, &actualSize).handleError()
        }
        return value == 0
    }
    
    func saveState() {
        CFPreferencesSetAppValue("fnState" as CFString, kCFBooleanFalse, "com.apple.keyboard" as CFString)
        CFPreferencesAppSynchronize("com.apple.keyboard" as CFString)
        CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFNotificationName.init(rawValue: "com.apple.keyboard.fnstatedidchange" as CFString), nil, nil, true)
    }
    
    func IOServiceConfig(_ action: (io_connect_t) -> Void) {
        var connect: io_connect_t = 0
        guard IOServiceOpen(service, mach_task_self_, UInt32(kIOHIDParamConnectType), &connect).asseredSuccess() else {
            return
        }
        action(connect)
        IOServiceClose(connect).handleError()
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
