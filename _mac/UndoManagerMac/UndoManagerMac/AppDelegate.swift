//
//  AppDelegate.swift
//  UndoManagerMac
//
//  Created by Bondar Yaroslav on 9/1/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let editMenu = NSApp.keyWindow!.menu!.items[2].submenu!
        editMenu.items.removeFirst()
        editMenu.items.removeFirst()
        
        editMenu.insertItem(withTitle: "Undo", action: #selector(MenuItems.undo), keyEquivalent: "z", at: 0)
        editMenu.insertItem(withTitle: "Redo", action: #selector(MenuItems.redo), keyEquivalent: "z", at: 1).keyEquivalentModifierMask = [.shift, .command]
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

/// need instead of NSSelectorFromString("undo:")
@objc private protocol MenuItems {
    func redo(_: Any?)
    func undo(_: Any?)
}
