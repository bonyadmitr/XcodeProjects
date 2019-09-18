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
    }
    
    @objc private func buttonAction() {
        print("button")
    }
}
