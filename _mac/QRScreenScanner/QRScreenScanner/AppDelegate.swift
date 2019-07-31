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
    
    /// https://habr.com/ru/post/447754/
    /// NSStatusItem.variableLength
    private let statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        guard let button = statusItem.button else {
            assertionFailure("system error. try statusItem.title")
            return statusItem
        }
        button.title = "QR"
        //button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        button.action = #selector(clickStatusItem)
        
        return statusItem
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private lazy var window: NSWindow? = {
        /// if you have error "doesn't contain a view controller with identifier" save storyboard manually cmd+s
        let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let windowIdentifier = NSStoryboard.SceneIdentifier("MainWindow")
        
        guard let mainWindowController = mainStoryboard.instantiateController(withIdentifier: windowIdentifier) as? NSWindowController else {
            assertionFailure()
            return nil
        }
        
        /// instead of "nil" can be "self"
        mainWindowController.showWindow(nil)
        
        return mainWindowController.window
    }()

    @objc private func clickStatusItem() {
        
        guard let img = ScreenshotMaker.mainScreenScreenshot() else {
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
        
        
//        "historyDataSource"
        
        for qrValue in CodeDetector.shared.readQR(from: img) {
            let newItem: HistoryDataSource = [TableColumns.date.rawValue: Date(),
                                              TableColumns.value.rawValue: qrValue]
            
            let tableDataSource: [HistoryDataSource]
            if var tableDataSourceOld = UserDefaults.standard.array(forKey: "historyDataSource") as? [HistoryDataSource] {
                tableDataSourceOld.append(newItem)
                tableDataSource = tableDataSourceOld
            } else {
                tableDataSource = [newItem]
            }
            UserDefaults.standard.set(tableDataSource, forKey: "historyDataSource")
            
        }
        
        
        
        guard let window = self.window else {
            assertionFailure()
            return
        }
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        /// to fix frame of closed window
//        window.setFrame(NSRect(x: 0, y: 0, width: 400, height: 300), display: true)
//        window.center()
        
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

final class ScreenshotMaker {
    
    static func mainScreenScreenshot() -> CGImage? {
        return CGDisplayCreateImage(CGMainDisplayID())
    }
}
