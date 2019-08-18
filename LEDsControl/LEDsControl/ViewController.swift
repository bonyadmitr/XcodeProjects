//
//  ViewController.swift
//  LEDsControl
//
//  Created by Yaroslav Bondar on 13/08/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let q = LedManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //q.reverseLed()
//        q.toggleLed()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.q.toggleLed()
            
            self.q.flashLed(duration: 0.3)
        }
        
//        try! changeSetting(setting: true)
//        saveState()
//        FnLock.singleton.onStateChange = { res in
//            print("---", res)
//        }
//        FnLock.singleton.run()
        
//        FnLock.singleton.toggleLed(state: true)
        
        
    }

    @IBAction func start(_ sender: Any) {
        Backlight.shared.on()
//        FnLock.singleton.run()
//        backlight.on()
    }
    
    @IBAction func stop(_ sender: Any) {
        Backlight.shared.off()
        Backlight.shared.stopFlashing()
    }
    
    @IBAction func timer(_ sender: Any) {
        Backlight.shared.startFlashing(target: self, interval: Backlight.MediumFlashingInterval, selector: #selector(toggle))
    }
    
    @objc private func toggle() {
        Backlight.shared.toggle()
    }
}

import IOKit.hid

/// IOKit.hid wrapper https://github.com/Jman012/SwiftyHID

final class LedManager {
    
    let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    let keyboard: IOHIDDevice
    let led: IOHIDElement
    
    var q = true
    
    init() {
        //setupManger()
        IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone)).handleError()
        
        let keyboardDictionary = [kIOHIDPrimaryUsageKey: kHIDUsage_GD_Keyboard] as CFDictionary
//        let keyboardDictionary: NSMutableDictionary = [
//            kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard,
//            kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop
//        ]
        
        /// ---- getKeyboard
        IOHIDManagerSetDeviceMatching(manager, keyboardDictionary)
        let matchingDevices = IOHIDManagerCopyDevices(manager) as! Set<IOHIDDevice>
        
        // IOUSBHostHIDDevice, IOHIDUserDevice
        // mac2015 AppleUSBTopCaseHIDDriver
        keyboard = matchingDevices.first { String(describing: $0).contains("IOUSBHostHIDDevice") } ?? matchingDevices.first!
        
        
        /// begin changes
        IOHIDDeviceOpen(keyboard, IOOptionBits(kIOHIDOptionsTypeSeizeDevice)).handleError()
        /// end changes
        //IOHIDDeviceClose(keyboard, IOOptionBits(kIOHIDOptionsTypeSeizeDevice)).handleError()
        
        /// ---- led
        let ledDictionary = [kIOHIDElementUsagePageKey: kHIDPage_LEDs, kIOHIDElementUsageKey: kHIDUsage_LED_CapsLock] as CFDictionary
        let elements = IOHIDDeviceCopyMatchingElements(keyboard, ledDictionary, IOOptionBits(kIOHIDOptionsTypeNone)) as! [IOHIDElement]
        
        led = elements.first!
    }
    
    func reverseLed() {
        let daemon = Thread(target: self, selector: #selector(start), object: nil)
        daemon.start()
    }
    
    @objc func start() {
        //        let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque());
        //
        //        let keyboardCallback: IOHIDValueCallback = {(context, ioreturn, sender, value) in
        //            let selfPtr = Unmanaged<LedManger>.fromOpaque(context!).takeUnretainedValue()
        //            print("---")
        //            //selfPtr.callback(ioreturn: ioreturn, sender: sender, value: value)
        //        }
        //
        //        IOHIDManagerRegisterInputValueCallback(manager, keyboardCallback, context)
        //        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
        
//        toggleLed()
        q = !isCapsLockOn()
        
        let ctx = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)

        IOHIDDeviceRegisterInputValueCallback(keyboard, { (context, result, sender, value) in

            let ledManger = unsafeBitCast(context, to: LedManager.self)

            let element = IOHIDValueGetElement(value)
            let elementValue = IOHIDValueGetIntegerValue(value)
            let usage = Int(IOHIDElementGetUsage(element))
            if usage == kHIDUsage_KeyboardCapsLock && elementValue == 0 {
                ledManger.q.toggle()
                ledManger.toggleLed(state: ledManger.q)
                print("- \(elementValue)")
            }
        }, ctx)
        
        /// need to update led after app switching
        /// there is bug after some switches
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateLed), userInfo: nil, repeats: true)

        RunLoop.current.run()
    }
    
//    private func setupManger() {
//        //let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
//        IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
//    }
    
    deinit {
        //IOHIDManagerClose(manager, IOOptionBits(kIOHIDOptionsTypeNone)).handleError()
    }
    
    func isCapsLockOn() -> Bool {
        /// kCFAllocatorDefault == nil, read doc
        let emptyValue = IOHIDValueCreateWithIntegerValue(kCFAllocatorDefault, led, 0, 0)
        var unmanagedValue = Unmanaged.passUnretained(emptyValue)
        
        IOHIDDeviceGetValue(keyboard, led, &unmanagedValue).handleError()
        
        let elementValue = IOHIDValueGetIntegerValue(unmanagedValue.takeUnretainedValue())
        return elementValue == 1
    }
    
    /// reset after app changes
    func toggleLed() {
        toggleLed(state: !isCapsLockOn())
    }
    
    func flashLed(duration: TimeInterval = 0.1) {
        let state = isCapsLockOn()
        toggleLed(state: !state)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.toggleLed(state: state)
        }
    }
    
    func toggleLed(state: Bool) {
        let value = IOHIDValueCreateWithIntegerValue(kCFAllocatorDefault, led, 0, state ? 1 : 0)
        IOHIDDeviceSetValue(keyboard, led, value).handleError()
    }
    
//    func q() {
//
//        let hidManagerRef = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
//        IOHIDManagerSetDeviceMatching(hidManagerRef, nil)
//
//        let hidManagerRet = IOHIDManagerOpen(hidManagerRef, IOOptionBits(kIOHIDOptionsTypeNone))
//        if (hidManagerRet != kIOReturnSuccess) {
//            print("Failed to open device manager")
//            exit(1)
//        }
//
//        let hidDeviceSet = IOHIDManagerCopyDevices(hidManagerRef)
//        let hidDeviceNum = CFSetGetCount(hidDeviceSet)
//
//        print(String(format: "Found %X devices", hidDeviceNum))
//
//        CFSetApplyFunction(hidDeviceSet, { value, context in
//            let hidDevice = Unmanaged<IOHIDDevice>.fromOpaque(value!).takeRetainedValue()
//            print(hidDevice)
//        }, nil)
//
//        IOHIDManagerClose(hidManagerRef, IOOptionBits(kIOHIDOptionsTypeNone))
//    }

    @objc func updateLed() {
        if q {
            toggleLed(state: q)
        }
    }
}

extension IOReturn {
    func handleError() {
        assert(self == kIOReturnSuccess, "reason: \(self)")
    }
}


















class FnLock: NSObject {
    static let singleton = FnLock()
    
    let manager = try! FnLock.setupManager()
    
    /// https://github.com/SkrewEverything/Swift-Keylogger/blob/master/Keylogger/Keylogger/Keylogger.swift
    // kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop
    // kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard
    let keyboardDictionary = [kIOHIDPrimaryUsageKey: kHIDUsage_GD_Keyboard] as CFDictionary
    let ledDictionary = [kIOHIDElementUsagePageKey: kHIDPage_LEDs, kIOHIDElementUsageKey: kHIDUsage_LED_CapsLock] as CFDictionary
    
    var state = getSettingSafe()
    var keyboard: IOHIDDevice?
    var led: IOHIDElement?
    var onStateChange: ((Bool) -> ())? = nil
    
    override init() {
        super.init()
        keyboard = getKeyboard()
        led = getLed()
    }
    
    class func setupManager() throws -> IOHIDManager {
        let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
        
        IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
        
        return manager
    }
    
    /// There is a .entitlements file included in the XCode project and you need to add a row for com.apple.security.device.usb and set it to "YES" for a Cocoa project
    /// https://stackoverflow.com/a/48070676
    func getKeyboard() -> IOHIDDevice {
        IOHIDManagerSetDeviceMatching(manager, keyboardDictionary)
        
        let matchingDevices = IOHIDManagerCopyDevices(manager) as! Set<IOHIDDevice>
        
        // IOUSBHostHIDDevice, IOHIDUserDevice
        // mac2015 AppleUSBTopCaseHIDDriver
        let w = matchingDevices.first { String(describing: $0).contains("IOUSBHostHIDDevice") } ?? matchingDevices.first!
        
        return w
        //return matchingDevices.anyObject() as! IOHIDDevice
    }
    
    func getLed() -> IOHIDElement {
        
        let elements = IOHIDDeviceCopyMatchingElements(keyboard!, ledDictionary, IOOptionBits(kIOHIDOptionsTypeNone)) as! Array<IOHIDElement>
        
        IOHIDDeviceOpen(keyboard!, IOOptionBits(kIOHIDOptionsTypeSeizeDevice))
        
        return elements[0]
    }
    
    func toggleLed(state: Bool) {
        let value = IOHIDValueCreateWithIntegerValue(kCFAllocatorDefault, led!, 0, state ? 1 : 0)
        let result = IOHIDDeviceSetValue(keyboard!, led!, value)
        assert(result == KERN_SUCCESS)
    }
    
    @objc func updateLed() {
        if self.state {
            toggleLed(state: self.state)
        }
    }
    
    @objc func run() {
        let ctx = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)

        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        
        IOHIDDeviceRegisterInputValueCallback(keyboard!, { (context, result, sender, value) in
            print(arc4random())
            let fnLock = unsafeBitCast(context, to: FnLock.self)

            let element = IOHIDValueGetElement(value)
            let elementValue = IOHIDValueGetIntegerValue(value)
            let usage = Int(IOHIDElementGetUsage(element))
            if usage == kHIDUsage_KeyboardCapsLock && elementValue == 0 {
                do {
                    try changeSetting(setting: !fnLock.state)
                    fnLock.toggleLed(state: !fnLock.state)
                    fnLock.state = try getSetting()
                    saveState()
//                    fnLock.onStateChange?(fnLock.state)
                } catch {
                    NSLog("failed to change fn setting to %s %s", !fnLock.state)
                }
            }

        }, ctx)
        
        // TODO: I have no idea why someone switches caps lock led off while user is switching windows
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateLed), userInfo: nil, repeats: true)
        
        RunLoop.current.run()
    }
    
}

enum IOServiceError: Error {
    case failedToGetMasterPort
    case failedToCreateMatchingDictionary
    case failedToChangeSetting
    case failedToGetSetting
}

func changeSetting(setting: Bool) throws {
    var enabled = setting ? UInt32(0) : UInt32(1)
    
    var connect: io_connect_t = 0
    
    let classToMatch = IOServiceMatching(kIOHIDSystemClass)
    
    let service = IOServiceGetMatchingService(kIOMasterPortDefault, classToMatch)
    
    guard IOServiceOpen(service, mach_task_self_, UInt32(kIOHIDParamConnectType), &connect) == kIOReturnSuccess else {
        NSLog("Failed to changeSetting: failed to open service")
        throw IOServiceError.failedToChangeSetting
    }
    
    guard IOHIDSetParameter(connect, kIOHIDFKeyModeKey as CFString, &enabled, 1) == kIOReturnSuccess else {
        NSLog("Failed to changeSetting: failed to set parameter")
        throw IOServiceError.failedToChangeSetting
    }
    
    guard IOServiceClose(connect) == kIOReturnSuccess else {
        NSLog("Failed to changeSetting: failed to close service")
        throw IOServiceError.failedToChangeSetting
    }
}

func getSetting() throws -> Bool {
    var connect: io_connect_t = 0
    
    let classToMatch = IOServiceMatching(kIOHIDSystemClass)
    
    let service = IOServiceGetMatchingService(kIOMasterPortDefault, classToMatch)
    
    guard IOServiceOpen(service, mach_task_self_, UInt32(kIOHIDParamConnectType), &connect) == kIOReturnSuccess else {
        NSLog("Failed to getSetting: failed to open service")
        throw IOServiceError.failedToGetSetting
    }
    
    var value = UInt32(0)
    var actualSize = UInt32(0)
    
    guard IOHIDGetParameter(connect, kIOHIDFKeyModeKey as CFString, 1, &value, &actualSize) == kIOReturnSuccess else {
        NSLog("Failed to getSetting: failed to get parameter")
        throw IOServiceError.failedToGetSetting
    }
    
    guard IOServiceClose(connect) == kIOReturnSuccess else {
        NSLog("Failed to getSetting: failed to close service")
        throw IOServiceError.failedToGetSetting
    }
    
    return value == 0
}

func getSettingSafe() -> Bool {
    do {
        return try getSetting()
    } catch {
        return false
    }
}

func saveState() {
    CFPreferencesSetAppValue("fnState" as CFString, kCFBooleanFalse, "com.apple.keyboard" as CFString)
    CFPreferencesAppSynchronize("com.apple.keyboard" as CFString)
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFNotificationName.init(rawValue: "com.apple.keyboard.fnstatedidchange" as CFString), nil, nil, true)
}


import Foundation

/// https://github.com/vecmezoni/fnlock
/// https://github.com/pmkary/starlight
/// https://gist.github.com/4np/14e8d996b659795b0572a4c45159c174

/// https://developer.apple.com/library/archive/samplecode/HID_LED_test_tool/Introduction/Intro.html
/// https://github.com/damieng/setledsmac

/// https://github.com/bhoeting/DiscoKeyboard
/// https://github.com/maxmouchet/LightKit
///
/// not working for macbook with touchbar
/// https://forums.developer.apple.com/thread/96414
/// https://github.com/maxmouchet/LightKit/issues/1

class Backlight {
    static let shared = Backlight()
    
    private var isOn = false
    private var isFlashing = false
    private var numberOfToggles = 0
    private var isFlashingOnce = false
    private var connect: mach_port_t = 0
    private var timer:Timer = Timer()
    
    static let FastFlashingInterval = 0.02
    static let MediumFlashingInterval = 0.06
    static let SlowFlashingInterval = 0.2
    static let MinBrightness:UInt64 = 0x0
    static var MaxBrightness:UInt64 = 0xfff
    
    
    
    init() {
        
        // Get the AppleLMUController (thing that accesses the light hardware)
        
        /// NOT working for mac2015 when call on()
//        let serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching(kIOHIDSystemClass))
        
        // TODO: check "AppleHIDKeyboardEventDriverV2"
        
        /// working for mac2015
        let serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleLMUController"))
        assert(serviceObject != 0, "Failed to get service object")
        
        // Open the AppleLMUController
        let status = IOServiceOpen(serviceObject, mach_task_self_, UInt32(kIOHIDParamConnectType), &connect)
        assert(status == KERN_SUCCESS, "Failed to open IO service")
        
        // Start with the backlight off
        on();
    }
    
    
    
    func startFlashing(target: AnyObject, interval: Float64, selector: Selector) {
        self.timer = Timer.scheduledTimer(
            timeInterval: interval, target: target, selector: selector, userInfo: nil, repeats: true)
        
        // We need to add the timer to the mainRunLoop so it doesn't stop flashing when the menu is accessed
        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
        self.isFlashing = true
    }
    
    func stopFlashing() {
        self.isFlashing = false
        self.timer.invalidate()
    }
    
    func toggle() {
        if self.isOn {
            self.off();
        } else {
            self.on();
        }
        
        self.numberOfToggles += 1
        if self.numberOfToggles >= 3 && isFlashingOnce {
            self.timer.invalidate()
            isFlashingOnce = false
        }
    }
    
    func on() {
        set(brightness: Backlight.MaxBrightness)
        isOn = true
    }
    
    func off() {
        set(brightness: Backlight.MinBrightness)
        isOn = false
    }
    
    func set(brightness: UInt64) {
        var output: UInt64 = 0
        var outputCount: UInt32 = 1
        let setBrightnessMethodId:UInt32 = 2
        let input: [UInt64] = [0, brightness]

        let status = IOConnectCallMethod(connect, setBrightnessMethodId, input, UInt32(input.count),
                                         nil, 0, &output, &outputCount, nil, nil)

        assert(status == KERN_SUCCESS, "Failed to set brightness; status: \(status)")
        
//        var outputs: UInt32 = 2
//        let values = UnsafeMutablePointer<UInt64>.allocate(capacity: Int(outputs))
//        let zero: UnsafeMutablePointer<Int> = UnsafeMutablePointer<Int>.allocate(capacity: 8)
//
//        guard IOConnectCallMethod(connect, 0, nil, 0, nil, 0, values, &outputs, nil, zero) == KERN_SUCCESS else {
//            debugPrint("Could not read ambient light sensor (2)")
//            return
//        }
//
//        let value = Int(values[0])
//        debugPrint("result: \(value)")
    }
    
    func printe(vale: Int32) {
        Backlight.MaxBrightness = UInt64(vale * 16)
    }
    
}
