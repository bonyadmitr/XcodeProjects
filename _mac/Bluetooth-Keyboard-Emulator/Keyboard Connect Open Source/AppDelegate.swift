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

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var btKey: BTKeyboard?

    
    func applicationDidFinishLaunching(_ notification: Notification) {
        startOrAskPermissions()
        
        /// "System Preferences - Security & Privacy - Privacy - Accessibility".
//        if !AXIsProcessTrusted() {
//            print("Enable accessibility setting to read keyboard events.")
//        }
//        start()
    }
    
    private let permissionManager = PermissionManager()
    
    private func startOrAskPermissions() {
        /// https://stackoverflow.com/a/36260107
//        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
//        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options)
        
        if permissionManager.isAccessibilityAvailable() {
            start()
        } else {
            askPermissions()
            startOrAskPermissions()
        }
//
//
//
//        guard permissionManager.isAccessibilityAvailable() else {
//
//            let alert = NSAlert()
//            alert.messageText = "Enable Maxxxro"
//            alert.informativeText = "Once you have enabled \"Keyboard Connect Open Source\" in System Preferences, click OK."
//            alert.addButton(withTitle: "Retry")
//
//            let result = alert.runModal()
//            let isButtonPressed = (result == .alertFirstButtonReturn)
//
//            /// if none buttons added
//            //let isButtonPressed = (result.rawValue == 0)
//
//            if isButtonPressed {
//                start()
//            } else {
//                askPermissions()
//            }
//
//            return
//        }
//
//        start()
    }
    
    func askPermissions() {
        let alert = NSAlert()
        alert.messageText = "Enable Maxxxro"
        alert.informativeText = "Once you have enabled \"Keyboard Connect Open Source\" in System Preferences, click OK."
        alert.addButton(withTitle: "Retry")
        alert.runModal()
//        let result = alert.runModal()
//        let isButtonPressed = (result == .alertFirstButtonReturn)
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
    
    func isAccessibilityAvailable() -> Bool {
        return AXIsProcessTrustedWithOptions(options)
    }
}
