//
//  AppDelegate.swift
//  Keyboard Connect Open Source
//
//  Created by Arthur Yidi on 4/11/16.
//  Copyright © 2016 Arthur Yidi. All rights reserved.
//

import AppKit
import Foundation
import IOBluetooth

func myCGEventCallback(proxy : CGEventTapProxy,
                       type : CGEventType,
                       event : CGEvent,
                       refcon : UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

    let oPtr = OpaquePointer(refcon)
    let btPtr = UnsafeMutablePointer<BTKeyboard>(oPtr)
    let btKey = btPtr?.pointee
    switch type {
    case .keyUp:
        if let nsEvent = NSEvent(cgEvent: event) {
            btKey?.sendKey(vkeyCode: -1, nsEvent.modifierFlags.rawValue)
        }
        break
    case .keyDown:
        if let nsEvent = NSEvent(cgEvent: event) {
            btKey?.sendKey(vkeyCode: Int(nsEvent.keyCode), nsEvent.modifierFlags.rawValue)
        }
        break
    default:
        break
    }

    return Unmanaged.passUnretained(event)
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let permissionManager = PermissionManager()
    private var btKey: BTKeyboard?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        startOrAskPermissions()
    }
    
    private func startOrAskPermissions() {
        if permissionManager.isAccessibilityAvailable() {
            start()
        } else {
            askPermissions()
            startOrAskPermissions()
        }
    }
    
    private func askPermissions() {
        let alert = NSAlert()
        let appName = "Keyboard Connect Open Source"
        alert.messageText = "Enable \(appName)"
        alert.informativeText = "Once you have enabled \"\(appName)\" in System Preferences, click OK."
        alert.addButton(withTitle: "Retry")
        alert.addButton(withTitle: "Quit")
        
        let result = alert.runModal()
        let isQuitButtonPressed = (result == .alertSecondButtonReturn)
        
        if isQuitButtonPressed {
            NSApp.terminate(self)
        }
    }
    
    private func start() {
        
        btKey = BTKeyboard()
        
        // capture all key events
        var eventMask: CGEventMask = 0
        eventMask |= (1 << CGEventMask(CGEventType.keyUp.rawValue))
        eventMask |= (1 << CGEventMask(CGEventType.keyDown.rawValue))
        eventMask |= (1 << CGEventMask(CGEventType.flagsChanged.rawValue))
        
        if let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                            place: .headInsertEventTap,
                                            options: .defaultTap,
                                            eventsOfInterest: eventMask,
                                            callback: myCGEventCallback,
                                            userInfo: &btKey) {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
            //CFRunLoopRun()
        } else {
            //assertionFailure()
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        btKey?.terminate()
    }
    
    deinit {
        print("-- deinit")
    }
}

final class PermissionManager {
//    static let shared = PermissionManager()
    
    let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
    
    /// "System Preferences - Security & Privacy - Privacy - Accessibility".
    func isAccessibilityAvailable() -> Bool {
        /// will not open system alert
        //return AXIsProcessTrusted()
        
        /// open system alert to the settings
        /// https://stackoverflow.com/a/36260107
        return AXIsProcessTrustedWithOptions(options)
    }
}
