//
//  AppDelegate.swift
//  QRScreenScanner
//
//  Created by Bondar Yaroslav on 7/23/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// NSStatusItem.variableLength
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        guard let button = statusItem.button else {
            assertionFailure("system error. try statusItem.title")
            return
        }
        button.title = "QR"
        //button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        button.action = #selector(clickStatusItem)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc private func clickStatusItem() {
        
        guard let img = CGDisplayCreateImage(CGMainDisplayID()) else {
            assertionFailure()
            return
        }
        
//        self.screenImageView.image = NSImage(cgImage: img, size: .init(width: img.width, height: img.height))
//
//        window.makeKeyAndOrderFront(nil)
        /// addition if need
        //NSApp.activate(ignoringOtherApps: true)
        /// not work
        //window.orderBack(self)
        
        print(
            CodeDetector.shared.readQR(from: img)
        )
        
        /// if you have error "doesn't contain a view controller with identifier" save storyboard manually cmd+s
        let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let windowIdentifier = NSStoryboard.SceneIdentifier("MainWindow")
        
        guard let mainWindowController = mainStoryboard.instantiateController(withIdentifier: windowIdentifier) as? NSWindowController else {
            assertionFailure()
            return
        }
        
        /// instead of "nil" can be "self"
        mainWindowController.showWindow(nil)
        
        guard let window = mainWindowController.window else {
            assertionFailure()
            return
        }
        
        window.makeKeyAndOrderFront(nil)
        
        /// to fix frame of closed window
        window.setFrame(NSRect(x: 0, y: 0, width: 400, height: 300), display: true)
        window.center()
        
        /// without reference it will be deinited
//        self.mainWindowController = mainWindowController
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

