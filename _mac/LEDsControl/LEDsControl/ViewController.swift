//
//  ViewController.swift
//  LEDsControl
//
//  Created by Yaroslav Bondar on 13/08/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    
    let q = LedManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playAudio()
        
        //q.reverseLed()
//        q.toggleLed()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////            self.q.toggleLed()
//            self.q.flashLed(duration: 0.1)
//        }
        
//        try! changeSetting(setting: true)
//        saveState()
//        FnLock.singleton.onStateChange = { res in
//            print("---", res)
//        }
//        FnLock.singleton.run()
        
//        FnLock.singleton.toggleLed(state: true)
        
        
    }
    
    func playAudio() {
        
        //let str = "https://cdn4.sefon.me/api/mp3_download/direct/101513/Tzy6ebvb2eCNhNWCIDFtVf5Z3nhUcz6zsVLJ38ogpao8GH7HDVedvESEBrB96km3/"
        //        let str = "https://www.kozco.com/tech/piano2-CoolEdit.mp3"
        let str = "https://cdn1.sefon.me/api/mp3_download/direct/101521/jDRBnIPGxj-A5CEUO0PDZ2vtr22B6rMfdBIjzpehCjs8GH7HDVedvESEBrB96km3/"
        
        let url = URL(string: str)!
        let data = try! Data(contentsOf: url)
        player = try! AVAudioPlayer(data: data)
        player.isMeteringEnabled = true
        player.prepareToPlay()
        player.play()
        
        Timer.scheduledTimer(withTimeInterval: timeUpdate, repeats: true) { timer in
            self.update()
        }
    }
    
    var player: AVAudioPlayer!
    
    //let timeUpdate: TimeInterval = 1/60 /// = 0.016
    let timeUpdate: TimeInterval = 0.05
    
    let lowerLimit: Float = -80.0
    let scale: Float = 1.0
    
    let meterTable = MeterTable(minDecibels: -80)!
    
    var lastMeter: Float = -160
    
    /**
     !!all https://github.com/serhii-londar/open-source-mac-os-apps#audio
     some https://github.com/topics/audio-visualizer?l=swift
     from the input device to the output https://github.com/jasminlapalme/caplaythrough-swift
     https://github.com/syedhali/EZAudio
     https://github.com/AudioKit/AudioKit
     https://github.com/maculateConception/aural-player
     
     
     using https://www.youtube.com/watch?v=dNYZOaf3Gvs
     https://github.com/mattingalls/Soundflower
     https://apple.stackexchange.com/q/221980
    */
    
    /// Audio Meter for AVPlayer
    /// https://github.com/naotokui/AVPlayerAudioMeter
    /// https://github.com/akhilcb/ACBAVPlayerExtension
    /// https://stackoverflow.com/a/40198405
    private func update() {
        guard player.isPlaying else {
            return
        }
        
        player.updateMeters()
        
        //let power: Float = (0..<player.numberOfChannels).reduce(0, { $0 + player.peakPower(forChannel: $1) }) / Float(player.numberOfChannels)
        let power: Float = (0..<player.numberOfChannels).reduce(0, { $0 + player.averagePower(forChannel: $1) }) / Float(player.numberOfChannels)
//        print(player.numberOfChannels, player.averagePower(forChannel: 0), player.averagePower(forChannel: 1))
//        print(power)
        
        /// or #1
        updateLed(for: power)
        
        
        let meter = meterTable.ValueAt(power)
        Backlight.shared.set(brightness: UInt64(Float(Backlight.MaxBrightness) * meter))
        
//        print(meter)
        /// or #2
//        updateLed(for: meter)
        
        
        /// https://stackoverflow.com/a/43179340
//        if power > lowerLimit {
//
//            /// proportion will have a value between 0 and scale
//            let proportion = -scale * (power - lowerLimit) / lowerLimit
//            //print(power, proportion)
//            //print(meter, proportion)
//            //print(proportion)
//
//            /// or #3
//            updateLed(for: proportion)
//        }
        
    }
    
    private func updateLed(for value: Float) {
        if lastMeter < value {
            //self.q.flashLed(duration: timeUpdate)
            q.changeStateTo(state: true)
//            Backlight.shared.on()
        } else {
            q.changeStateTo(state: false)
//            Backlight.shared.off()
        }
        lastMeter = value
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

/// https://github.com/ooper-shlab/avTouch1.4.3-Swift/blob/master/MeterTable.swift
class MeterTable {
    
    func ValueAt(_ inDecibels: Float) -> Float {
        if inDecibels < mMinDecibels  {
            return 0.0
        }
        if inDecibels >= 0.0 {
            return 1.0
        }
        let index = Int(inDecibels * mScaleFactor)
        return mTable[index]
    }
    private var mMinDecibels: Float
    private var mDecibelResolution: Float
    private var mScaleFactor: Float
    private var mTable: [Float] = []
    
    private final class func DbToAmp(_ inDb: Double) -> Double {
        return pow(10.0, 0.05 * inDb)
    }
    
    // MeterTable constructor arguments:
    // inNumUISteps - the number of steps in the UI element that will be drawn.
    //                    This could be a height in pixels or number of bars in an LED style display.
    // inTableSize - The size of the table. The table needs to be large enough that there are no large gaps in the response.
    // inMinDecibels - the decibel value of the minimum displayed amplitude.
    // inRoot - this controls the curvature of the response. 2.0 is square root, 3.0 is cube root. But inRoot doesn't have to be integer valued, it could be 1.8 or 2.5, etc.
    init?(minDecibels inMinDecibels: Float = -80.0, tableSize inTableSize: Int = 400, root inRoot: Float = 2.0) {
        mMinDecibels = inMinDecibels
        mDecibelResolution = mMinDecibels / Float(inTableSize - 1)
        mScaleFactor = 1.0 / mDecibelResolution
        if inMinDecibels >= 0.0 {
            print("MeterTable inMinDecibels must be negative", terminator: "")
            return nil
        }
        
        mTable = Array(repeating: 0.0, count: inTableSize)
        
        let minAmp = MeterTable.DbToAmp(Double(inMinDecibels))
        let ampRange = 1.0 - minAmp
        let invAmpRange = 1.0 / ampRange
        
        let rroot = 1.0 / Double(inRoot)
        for i in 0..<inTableSize {
            let decibels = Double(i) * Double(mDecibelResolution)
            let amp = MeterTable.DbToAmp(decibels)
            let adjAmp = (amp - minAmp) * Double(invAmpRange)
            mTable[i] = Float(pow(adjAmp, rroot))
        }
    }
    
}


import IOKit.hid
import Carbon

// TODO: flashLed number of times + defalut numbers for alerts

/// IOKit.hid wrapper https://github.com/Jman012/SwiftyHID

/// activateCapsLock https://github.com/superpanic/SuperCapsLock/blob/master/CapsLockLight/AppDelegate.swift
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
//        observe()
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
                ledManger.changeStateTo(state: ledManger.q)
                print("- \(elementValue)")
            }
        }, ctx)
        
        /// need to update led after app switching
        /// there is bug after some switches
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateLed), userInfo: nil, repeats: true)

        RunLoop.current.run()
    }
    
    /// not finished
    private func observe() {
        isLed = isCapsLockOn()
        _ = NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didActivateApplicationNotification, object: nil, queue: .main) { notification in
            guard
                let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
                let id = app.bundleIdentifier ?? app.executableURL?.lastPathComponent
            else {
                assertionFailure()
                return
            }
            
            print(app, id)
            
            print(self.isLed)
            
            /// working through one time
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                self.changeStateTo(state: self.isLed)
            })
            
            /// sometimes need more than 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.changeStateTo(state: self.isLed)
            })
//            DispatchQueue.main.async {
//                self.changeStateTo(state: self.isLed)
//            }
//            self.changeStateTo(state: self.isLed)
        }
//                NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(activeAppDidChange(notification:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
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
    
    /// import Carbon
    func isCapsLockOn2() -> Bool {
        let eventModifier: UInt32 = GetCurrentKeyModifiers()
        return eventModifier == 1024
    }
    
    /// reset after app changes
    func toggleLed() {
        //print(isCapsLockOn(), isCapsLockOn2())
        let state = isCapsLockOn()
        isLed = !state
        changeStateTo(state: !state)
    }
    
    private var isLed = false
    
    func flashLed(duration: TimeInterval = 0.1) {
        let state = isCapsLockOn()
        changeStateTo(state: !state)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.changeStateTo(state: state)
        }
    }
    
    func changeStateTo(state: Bool) {
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
            changeStateTo(state: q)
        }
    }
}

extension IOReturn {
    func handleError() {
        assert(self == kIOReturnSuccess, "reason: \(self)")
    }
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

/// fade https://github.com/superpanic/SuperCapsLock/blob/master/CapsLockLight/KeyboardBacklight.swift
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
        
        /// not working "AppleHIDKeyboardEventDriverV2"
        /// created but is not opening for mac with touchbar
        //let serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOUSBHostHIDDevice"))
        
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
        if System.is2016orMore {
            return
        }
        
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

enum System {
    
    /// "MacBookPro11,4" for MacBook Pro 15" Mid-2015
    /// "MacBookPro13,1" for MacBook Pro 13" Late 2016
    static let hardwareModel: String = {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        return String(cString: model)
    }()
    
    static let is2016orMore: Bool = {
        /// "MacBookPro".count
        let modelStartOffset = 10
        assert(modelStartOffset == "MacBookPro".count)
        
        let startIndex = hardwareModel.index(hardwareModel.startIndex, offsetBy: modelStartOffset)
        let endIndex = hardwareModel.index(startIndex, offsetBy: 2)
        let model = hardwareModel[startIndex..<endIndex]
        assert(!model.isEmpty)
        
        if let modelNumber = Int(model) {
            return modelNumber >= 13
        } else {
            assertionFailure("unknown model")
            return false
        }
    }()
}
