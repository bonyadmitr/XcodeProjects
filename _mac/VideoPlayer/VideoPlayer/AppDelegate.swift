//
//  AppDelegate.swift
//  VideoPlayer
//
//  Created by Bondar Yaroslav on 5/27/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var mainWindowController: NSWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let windowIdentifier = NSStoryboard.SceneIdentifier("MainWindow")
        
        guard let mainWindowController = mainStoryboard.instantiateController(withIdentifier: windowIdentifier) as? NSWindowController else {
            assertionFailure()
            return
        }
        
        /// instead of "nil" can be "self"
        mainWindowController.showWindow(nil)
        mainWindowController.window?.makeKeyAndOrderFront(nil)
        
        /// to fix frame of closed window
        mainWindowController.window?.setFrame(NSRect(x: 0, y: 0, width: 400, height: 300), display: true)
        mainWindowController.window?.center()
        
        /// without reference it will be deinited
        self.mainWindowController = mainWindowController
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    /// to open app after close button click we only hide it
    /// https://stackoverflow.com/a/43332520
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                window.makeKeyAndOrderFront(self)
            }
        }
        
        return true
    }
}

