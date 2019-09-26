//
//  AppDelegate.swift
//  TouchBarTest
//
//  Created by Yaroslav Bondar on 17/09/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        0x200000001000000
//        0x300000080500000
        let actuatorRef = MTActuatorCreateFromDeviceID(0x300000080500000).takeRetainedValue()
        let result = MTActuatorOpen(actuatorRef)
        if result != kIOReturnSuccess {
            print("private api not working")
        }
        
        
        HapticFeedback.shared.tap(strong: 6)
        TouchBarManager.shared.setup()
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

final class Window: NSWindow {
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        return TouchBarManager.shared.touchBar
    }
}


import Cocoa

@available(OSX 10.12.2, *)
private extension NSTouchBarItem.Identifier {
    static let system = NSTouchBarItem.Identifier("system")
    static let button = NSTouchBarItem.Identifier("button")
    static let segment = NSTouchBarItem.Identifier("segment")
}

@available(OSX 10.12.2, *)
private extension NSTouchBar.CustomizationIdentifier {
    static let main = "Main"
}



@available(OSX 10.12.2, *)
final class TouchBarManager: NSObject, NSTouchBarProvider {
    
    static let shared = TouchBarManager()
    
    let touchBar: NSTouchBar? = {
        let touchBar = NSTouchBar()
        touchBar.customizationIdentifier = .main
        touchBar.defaultItemIdentifiers = [.button, .segment]
        touchBar.customizationAllowedItemIdentifiers = [.button, .segment, .fixedSpaceSmall, .fixedSpaceLarge, .flexibleSpace, .otherItemsProxy]
        return touchBar
    }()
    
    /**
     used private api
     1. add TouchBar.h
     2. add PROJECT_NAME-Bridging-Header.h with contens #import "TouchBar.h"
        (add path in Build Settings - Objective-C Bridging Header)
     3. add $(SYSTEM_LIBRARY_DIR)/PrivateFrameworks to Build Settings - Framework Search Paths
     4. Build Phases - Link Binary With Libraries - add DFRFoundation.framework
     (path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/PrivateFrameworks/DFRFoundation.framework)
     
     private api https://stackoverflow.com/a/49826928
     private api https://github.com/a2/touch-baer
     https://github.com/Toxblh/MTMR
     https://github.com/bikkelbroeders/TouchBarDemoApp
     */
    private func setupControlStripPresence() {
        
        /// need?
        //DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        
        let item = NSCustomTouchBarItem(identifier: .system)
        item.view = NSButton(title: "🐹",
                             target: self,
                             action: #selector(systemItemAction))
        NSTouchBarItem.addSystemTrayItem(item)
        DFRElementSetControlStripPresenceForIdentifier(.system, true)
    }
    
    @objc private func systemItemAction() {
        NSTouchBar.presentSystemModalTouchBar(touchBar, systemTrayItemIdentifier: .system)
//        if #available(macOS 10.14, *) {
//            NSTouchBar.presentSystemModalTouchBar(touchBar, systemTrayItemIdentifier: .system)
//        } else {
//            NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: .system)
//        }
    }
    
    func setup() {
        touchBar?.delegate = self
        NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        setupControlStripPresence()
        //            NSApp.touchBar
    }
    
}

@available(OSX 10.12.2, *)
extension TouchBarManager: NSTouchBarDelegate {
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        /// not good solution bcz there are other NSTouchBarItems like NSPopoverTouchBarItem
        let item = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case .segment:
            item.customizationLabel = "Segment label"
            
            item.view = NSSegmentedControl(labels: ["1", "2", "3"],
                                           trackingMode: .momentary,
                                           target: self,
                                           action: #selector(segmentAction))
            
        case .button:
            item.customizationLabel = "Button label"
            
            item.view = NSButton(title: "Button",
                                 target: self,
                                 action: #selector(buttonAction))
            
        default:
            break
            //            assertionFailure("unknown id: \(identifier.rawValue)")
        }
        
        return item
    }
    
    @objc private func segmentAction(_ sender: NSSegmentedControl) {
        print(sender.selectedSegment)
        
        switch sender.selectedSegment {
        case 0:
            HapticFeedback.shared.tap(strong: 1)
        case 1:
            HapticFeedback.shared.tap(strong: 2)
        case 2:
            HapticFeedback.shared.tap(strong: 3)
        default:
            assertionFailure()
        }
    }
    
    @objc private func buttonAction() {
        HapticFeedback.shared.tap(strong: 2)
        print("button")
    }
}

import IOKit

/// source https://github.com/Toxblh/MTMR/blob/master/MTMR/HapticFeedback.swift
class HapticFeedback {
    static let shared = HapticFeedback()
    
    // Here we have list of possible IDs for Haptic Generator Device. They are not constant
    // To find deviceID, you will need IORegistryExplorer app from Additional Tools for Xcode dmg
    // which you can download from https://developer.apple.com/download/more/?=Additional%20Tools
    // Open IORegistryExplorer app, search for AppleMultitouchDevice and get "Multitouch ID"
    // There should be programmatic way to get it but I can't find, no docs for macOS :(
    private let possibleDeviceIDs: [UInt64] = [
        0x200_0000_0100_0000, // MacBook Pro 2016/2017
        0x300000080500000 // MacBook Pro 2019 (possibly 2018 as well)
    ]
    private var correctDeviceID: UInt64?
    private var actuatorRef: CFTypeRef?
    
    init() {
        recreateDevice()
    }
    
    // Don't know how to do strong is enum one of
    // 1 like back Click
    // 2 like Click
    // 3 week
    // 4 medium
    // 5 week medium
    // 6 strong
    // 15 nothing
    // 16 nothing
    // you can get a plist `otool -s __TEXT __tpad_act_plist /System/Library/PrivateFrameworks/MultitouchSupport.framework/Versions/Current/MultitouchSupport|tail -n +3|awk -F'\t' '{print $2}'|xxd -r -p`
    
    func tap(strong: Int32) {
        guard correctDeviceID != nil, actuatorRef != nil else {
            print("guard actuatorRef == nil (no haptic device found?)")
            return
        }
        
        var result: IOReturn
        
        result = MTActuatorOpen(actuatorRef!)
        guard result == kIOReturnSuccess else {
            print("guard MTActuatorOpen")
            recreateDevice()
            return
        }
        
        result = MTActuatorActuate(actuatorRef!, strong, 0, 0, 0)
        guard result == kIOReturnSuccess else {
            print("guard MTActuatorActuate")
            return
        }
        
        result = MTActuatorClose(actuatorRef!)
        guard result == kIOReturnSuccess else {
            print("guard MTActuatorClose")
            return
        }
    }
    
    private func recreateDevice() {
        if let actuatorRef = actuatorRef {
            MTActuatorClose(actuatorRef)
            self.actuatorRef = nil // just in case %)
        }
        
        if let correctDeviceID = correctDeviceID {
            actuatorRef = MTActuatorCreateFromDeviceID(correctDeviceID).takeRetainedValue()
        } else {
            // Let's find our Haptic device
            possibleDeviceIDs.forEach {(deviceID) in
                guard correctDeviceID == nil else {return}
                actuatorRef = MTActuatorCreateFromDeviceID(deviceID).takeRetainedValue()
                
                if actuatorRef != nil {
                    correctDeviceID = deviceID
                }
            }
        }
    }
}
