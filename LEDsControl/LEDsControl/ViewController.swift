//
//  ViewController.swift
//  LEDsControl
//
//  Created by Yaroslav Bondar on 13/08/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    private let backlight = Backlight.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func start(_ sender: Any) {
        backlight.on()
    }
    
    @IBAction func stop(_ sender: Any) {
        backlight.off()
    }
    
    @IBAction func timer(_ sender: Any) {
        backlight.startFlashing(target: self, interval: Backlight.MediumFlashingInterval, selector: #selector(toggle))
    }
    
    @objc private func toggle() {
        backlight.toggle()
    }
}


import Foundation

/// https://github.com/vecmezoni/fnlock

/// https://github.com/maxmouchet/LightKit
///
/// not working for macbook with touchbar or in High Sierra
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
        let serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                        IOServiceMatching("AppleLMUController"))
        assert(serviceObject != 0, "Failed to get service object")
        
        // Open the AppleLMUController
        let status = IOServiceOpen(serviceObject, mach_task_self_, 0, &connect)
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
    }
    
    func printe(vale: Int32) {
        Backlight.MaxBrightness = UInt64(vale * 16)
    }
    
}
