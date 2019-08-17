import Cocoa

final class WindowsManager: NSObject {
    
//    override init() {
//        super.init()
//    }
    
    /// if it is not lazy controller will be loaded immediately
    ///
    /// window style https://lukakerr.github.io/swift/nswindow-styles
    lazy var window: NSWindow = {
        let vc = ViewController()
        let window = NSWindow(vc: vc)
        window.title = App.name
        
        /// animation not always work for start window
        window.animationBehavior = .none
        
        /// https://stackoverflow.com/a/42984241/5893286
        /// when the window is the full size cost more memory
        window.contentView?.wantsLayer = true
        
        window.center()
        /// call it after .center()
        window.setFrameAutosaveName("MainWindow")
        return window
    }()
    
    func showWindow() {
        //window.orderFront(nil)
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

private extension NSWindow {
    
    /// same as self.init(contentViewController: vc)
    convenience init(vc: NSViewController) {
        self.init(contentRect: vc.view.frame,
                  styleMask: [.titled, .closable, .miniaturizable, .resizable],
                  backing: .buffered,
                  defer: true)
        contentViewController = vc
        isReleasedWhenClosed = false
        
        /// or #1
        //bind(.title, to: vc, withKeyPath: #keyPath(NSViewController.title), options: nil)
        /// or #2
        if let title = vc.title {
            self.title = title
        }
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
