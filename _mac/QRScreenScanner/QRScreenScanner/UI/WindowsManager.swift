//
//  WindowsManager.swift
//  QRScreenScanner
//
//  Created by Bondar Yaroslav on 8/17/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

final class WindowsManager: NSObject {
    
    override init() {
        super.init()
        print("- WindowsManager")
    }
    
    /// if it is not lazy controller will be loaded immediately
    ///
    /// window style https://lukakerr.github.io/swift/nswindow-styles
    lazy var window: NSWindow = {
        let vc = ViewController()
        //let window = NSWindow(contentViewController: vc)
        let window = NSWindow(contentRect: vc.view.frame,
                              styleMask: [.titled, .closable, .miniaturizable, .resizable],
                              backing: .buffered,
                              defer: true)
        window.contentViewController = vc
        window.title = App.name //window.title = vc.title
        window.isReleasedWhenClosed = false
        //window.animationBehavior = .utilityWindow
        
        /// https://stackoverflow.com/a/42984241/5893286
        /// when the window is the full size cost more memory
        window.contentView?.wantsLayer = true
        
        window.center()
        /// call it after .center()
        window.setFrameAutosaveName("MainWindow")
        return window
    }()
    
    func start() {
        
    }
    
    func showWindow() {
        //window.orderFront(nil)
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

// MARK: - NSWindowRestoration

//window.isRestorable = true
//window.restorationClass = WindowsManager.self //type(of: self)
//window.identifier = NSUserInterfaceItemIdentifier(rawValue: "MainWindow") //String(describing: type(of: self))

//window.restoreState(with: state)

//final class MainWindowController: NSWindowController {
//    override func restoreState(with coder: NSCoder) {
//    }
//}
//
//final class MainWindow: NSWindow {
//    override func restoreState(with coder: NSCoder) {
//        //coder.encode(<#T##object: Any?##Any?#>, forKey: <#T##String#>)
//    }
//}

/// now the app restores its state only when you quit using Command-Option-Q.
/// https://stackoverflow.com/a/12894388/5893286
///
/// https://github.com/zcohan/RestorableWindowControllers
/// https://github.com/michelf/sim-daltonism/blob/master/Mac%20App/FilterWindowManager.swift
//extension WindowsManager: NSWindowRestoration {
//    public static func restoreWindow(withIdentifier identifier: NSUserInterfaceItemIdentifier, state: NSCoder, completionHandler: @escaping (NSWindow?, Error?) -> Void) {
//
//        //assert(String(describing: self) == identifierComponents.last, "unexpected restoration path: \(identifierComponents)")
//
//        if identifier.rawValue == "MainWindow" {
//            let window = NSWindow()
//            completionHandler(window, nil)
//        } else {
//            completionHandler(nil, nil)
//        }
//    }
//}
