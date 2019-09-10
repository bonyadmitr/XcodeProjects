//
//  AppDelegate.swift
//  QRScreenScanner
//
//  Created by Bondar Yaroslav on 7/23/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        App.shared.start()
        NSApp.registerUserInterfaceItemSearchHandler(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {}
    
    /// to open app after close button click we only hide it
    /// https://stackoverflow.com/a/43332520
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            sender.windows.forEach { $0.makeKeyAndOrderFront(self) }
        }
        
        return true
    }
    
    /// doc: If the user started up the application by double-clicking a file, the delegate receives the application(_:openFile:) message before receiving applicationDidFinishLaunching(_:). (applicationWillFinishLaunching(_:) is sent before application(_:openFile:).)
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        QRService.scanFiles(at: [filename])
        return true
    }
}

extension AppDelegate: NSUserInterfaceItemSearching {
    
    func searchForItems(withSearch searchString: String, resultLimit: Int, matchedItemHandler handleMatchedItems: @escaping ([Any]) -> Void) {
        handleMatchedItems(["w1", "w2"])
    }
    
    func localizedTitles(forItem item: Any) -> [String] {
        return ["\(item) q", "\(item) w"]
    }
    
    func performAction(forItem item: Any) {
        print(item)
    }
}
