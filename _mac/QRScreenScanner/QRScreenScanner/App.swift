import Cocoa

// TODO: dock manager
// TODO: https://stackoverflow.com/a/9220857/5893286
// TODO: https://stackoverflow.com/a/50832237/5893286 + https://stackoverflow.com/a/4686782/5893286
// TODO: https://developer.apple.com/library/archive/technotes/tn2083/_index.html

// TODO: menu for empty tableview
// TODO: more actions in edit menu
// TODO: feedback button

// TODO: view bases tableview
// TODO: delete button in table
// TODO: multiline text

// TODO: clear controller

// TODO: Quick Alert nothing found
// TODO: Add contact from qr
// TODO: Icon
// TODO: Status icon

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


/// https://stackoverflow.com/a/12894388/5893286
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

final class App {
    
    static let shared = App()
    
    let statusItemManager = StatusItemManager()
    let menuManager = MenuManager()
    let toolbarManager = ToolbarManager()
    let windowsManager = WindowsManager()
    
    /// if it is not lazy controller will be loaded immediately
    ///
    /// window style https://lukakerr.github.io/swift/nswindow-styles
//    private lazy var window: NSWindow = {
//        let vc = ViewController()
//        //let window = NSWindow(contentViewController: vc)
//        let window = NSWindow(contentRect: vc.view.frame,
//                              styleMask: [.titled, .closable, .miniaturizable, .resizable],
//                              backing: .buffered,
//                              defer: true)
//        window.contentViewController = vc
//        window.title = App.name //window.title = vc.title
//        window.isReleasedWhenClosed = false
//
//        window.isRestorable = true
//        window.restorationClass = WindowsManager.self //type(of: self)
//        window.identifier = NSUserInterfaceItemIdentifier(rawValue: "MainWindow") //String(describing: type(of: self))
//        //window.animationBehavior = .utilityWindow
//
//        /// https://stackoverflow.com/a/42984241/5893286
//        /// when the window is the full size cost more memory
//        window.contentView?.wantsLayer = true
//
//        window.center()
//        /// call it after .center()
//        window.setFrameAutosaveName("MainWindow")
//        return window
//    }()
    
    func start() {
        menuManager.setup()
        statusItemManager.setup()
        toolbarManager.addToWindow(windowsManager.window)
//        windowsManager.showWindow()
        showWindow()
    }
    
    func showWindow() {
        windowsManager.showWindow()
        
//        //window.orderFront(nil)
//        window.makeKeyAndOrderFront(nil)
//        NSApp.activate(ignoringOtherApps: true)
    }
}

extension App {
    static let id = Bundle.main.bundleIdentifier.assert(or: "")
    static let name = (Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String).assert(or: "")
    static let version = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String).assert(or: "")
    static let build = (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String).assert(or: "")
    static let versionWithBuild = "\(version) (\(build))"
    
    static func openSubmitFeedbackPage() {
        let feedbackBody =
        """
        qwe
        <!--
        Provide your feedback here. Include as many details as possible.
        You can also email me at bonyadmitr@gmail.com
        -->
        
        ---
        \(App.name) \(App.versionWithBuild)
        macOS \(System.osVersion)
        \(System.hardwareModel)
        """
        
        guard
            let encodedBody = feedbackBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            /// can be added title: "&title=\(title)"
            let url = URL(string: "https://github.com/bonyadmitr/XcodeProjects/issues/new?body=\(encodedBody)")
        else {
            assertionFailure()
            return
        }
        
        NSWorkspace.shared.open(url)
    }
}
