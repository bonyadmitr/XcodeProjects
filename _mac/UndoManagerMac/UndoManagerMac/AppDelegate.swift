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

/// needs instead of NSSelectorFromString("undo:")
/// with '#selector(UndoManager.undo)' will not work undoManager.setActionName. it will be like any custom action
@objc private protocol MenuItems {
    func redo(_: Any?)
    func undo(_: Any?)
}

/// to fix IB bug. redo not showing in FirstResponder.
/// if removed actions from undo/redo menu items.
/// set actions in IB and comment this extension.
//private extension NSResponder {
//
//    @IBAction func redo(_: Any?) {
//        assertionFailure()
//    }
//
////    @IBAction func undo(_: Any?) {
////        assertionFailure()
////    }
//}
