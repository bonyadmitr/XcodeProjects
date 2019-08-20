//
//  ViewController.swift
//  FnLock
//
//  Created by Bondar Yaroslav on 8/20/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

// TODO: add status button
// TODO: clear class
// TODO: clear from storyboard

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FnLock.shared.toggle()
    }
}

/// not working in sandbox
/// System Preferences will be updated after relaunch of it
///
/// https://github.com/vecmezoni/fnlock
/// https://github.com/Pyroh/Fluor/blob/master/Fluor/utils.m
/// usefull app, associated by apps https://github.com/Pyroh/Fluor
/// apple script https://github.com/jakubroztocil/macos-fn-toggle
final class FnLock {
    
    static let shared = FnLock()
    
    private let service: io_service_t
    
    init() {
        let classToMatch = IOServiceMatching(kIOHIDSystemClass)
        service = IOServiceGetMatchingService(kIOMasterPortDefault, classToMatch)
    }
    
    var isFnActive: Bool {
        get {
            var value: UInt32 = 0
            var actualSize: IOByteCount = 0
            
            IOServiceConfig { connect in
                IOHIDGetParameter(connect, kIOHIDFKeyModeKey as CFString, 1, &value, &actualSize).handleError()
            }
            return value == 0
        }
        set {
            /// dirty test
            #if DEBUG
            let isFnActiveTest = self.isFnActive
            #endif
            
            var enabled: UInt32 = newValue ? 0 : 1
            IOServiceConfig { connect in
                /// in sandbox crash here
                IOHIDSetParameter(connect, kIOHIDFKeyModeKey as CFString, &enabled, 1).handleError()
            }
            
            #if DEBUG
            assert(isFnActiveTest == !self.isFnActive, "state is not changed")
            #endif
        }
    }
    
    func toggle() {
        isFnActive.toggle()
    }
    
    private func IOServiceConfig(_ action: (io_connect_t) -> Void) {
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


/// should change UI in System Preferences --> Keyboard --> Use F1..., but it not working.
/// System Preferences will be updated after relaunch of it
//private func saveState(isEnabled: Bool) {
//    let setValue = isEnabled ? kCFBooleanTrue : kCFBooleanFalse
//    CFPreferencesSetAppValue("fnState" as CFString, setValue, "com.apple.keyboard" as CFString)
//    CFPreferencesAppSynchronize("com.apple.keyboard" as CFString)
//    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFNotificationName.init(rawValue: "com.apple.keyboard.fnstatedidchange" as CFString), nil, nil, true)
//}
