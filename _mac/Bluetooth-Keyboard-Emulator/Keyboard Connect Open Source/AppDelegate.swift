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

var btKey: BTKeyboard?

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidBecomeActive(_ notification: Notification) {
        btKey = BTKeyboard()

        if !AXIsProcessTrusted() {
            print("Enable accessibility setting to read keyboard events.")
        }

        // capture all key events
        var eventMask: CGEventMask = 0
        eventMask |= (1 << CGEventMask(CGEventType.keyUp.rawValue))
        eventMask |= (1 << CGEventMask(CGEventType.keyDown.rawValue))
        eventMask |= (1 << CGEventMask(CGEventType.flagsChanged.rawValue))

        if let eventTap = CGEvent.tapCreate(tap:.cgSessionEventTap,
                                            place:.headInsertEventTap,
                                            options:CGEventTapOptions.defaultTap,
                                            eventsOfInterest:eventMask,
                                            callback:myCGEventCallback,
                                            userInfo:&btKey) {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        btKey?.terminate()
    }
    
    deinit {
        print("-- deinit")
    }
}
