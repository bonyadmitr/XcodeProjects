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

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let permissionManager = PermissionManager()
    private var btKey: BTKeyboard?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        startOrAskPermissions()
    }
    
    private func startOrAskPermissions() {
        if permissionManager.isAccessibilityAvailableWithoutAlert() {
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
        alert.addButton(withTitle: "Open System Preference")
        alert.addButton(withTitle: "Quit")
        
        let result = alert.runModal()
//        let isQuitButtonPressed = (result == .alertSecondButtonReturn)
//
//        if isQuitButtonPressed {
//            NSApp.terminate(self)
//        }
        
        switch result {
        case .alertFirstButtonReturn:
            break
        case .alertSecondButtonReturn:
            openSecurityPane()
        case .alertThirdButtonReturn:
            NSApp.terminate(self)
        default:
            assertionFailure()
        }
    }
    
    /// https://macosxautomation.com/system-prefs-links.html
    /// https://stackoverflow.com/a/6658201
    func openSecurityPane() {
        let prefpaneUrl = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(prefpaneUrl)

        // openURL 使うのが最も簡単だが、アクセシビリティの項目まで選択された状態で開くことができない
//        NSWorkspace.shared.open( NSURL.fileURL(withPath: "/System/Library/PreferencePanes/Security.prefPane") )
        
        // ScriptingBridge を使い、表示したいところまで自動で移動させる
        // open System Preference -> Security and Privacy -> Accessibility
//        let prefs = SBApplication.applicationWithBundleIdentifier("com.apple.systempreferences")! as! SBSystemPreferencesApplication
//        prefs.activate()
//        for pane_ in prefs.panes! {
//            let pane = pane_ as! SBSystemPreferencesPane
//            if pane.id == "com.apple.preference.security" {
//                for anchor_ in pane.anchors! {
//                    let anchor = anchor_ as! SBSystemPreferencesAnchor
//                    if anchor.name == "Privacy_Accessibility" {
//                        println(pane, anchor)
//                        anchor.reveal!()
//                        break
//                    }
//                }
//                break
//            }
//        }
    }
    
    private func start() {
        
        btKey = BTKeyboard()
        
        let cgEventCallback: CGEventTapCallBack = { _, eventType, cgEvent, rawPointer in
            let opaquePointer = OpaquePointer(rawPointer)
            guard let btPtr = UnsafeMutablePointer<BTKeyboard>(opaquePointer), let event = NSEvent(cgEvent: cgEvent) else {
                assertionFailure()
                return nil
            }
            let btKey = btPtr.pointee
            switch eventType {
            case .keyUp:
                btKey.sendKey(vkeyCode: -1, event.modifierFlags.rawValue)
            case .keyDown:
                btKey.sendKey(vkeyCode: Int(event.keyCode), event.modifierFlags.rawValue)
            default:
                break
            }

            return Unmanaged.passUnretained(cgEvent)
        }
        
        /// https://stackoverflow.com/a/31898592
        let eventMask: CGEventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
        
        guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                            place: .headInsertEventTap,
                                            options: .defaultTap,
                                            eventsOfInterest: eventMask,
                                            callback: cgEventCallback,
                                            userInfo: &btKey)
        else {
            assertionFailure("called without Accessibility permission. search AXIsProcessTrustedWithOptions")
            return
        }
        
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        //CFRunLoopRun()
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

/// AXObserverAddNotification
/// https://stackoverflow.com/questions/853833/how-can-my-app-detect-a-change-to-another-apps-window
///
final class PermissionManager {
//    static let shared = PermissionManager()
    
    /// "System Preferences - Security & Privacy - Privacy - Accessibility".
    func isAccessibilityAvailable() -> Bool {
        /// will not open system alert
        //return AXIsProcessTrusted()
        
        /// open system alert to the settings
        /// https://stackoverflow.com/a/36260107
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
    
    func isAccessibilityAvailableWithoutAlert() -> Bool {
        /// will not open system alert
        /// or #1
        return AXIsProcessTrusted()
        
        /// or #2
        //let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): false] as CFDictionary
        //return AXIsProcessTrustedWithOptions(options)
    }
}
