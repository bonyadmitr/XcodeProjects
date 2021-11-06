import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var mainWindow: NSWindow?
    private var controller: ViewController?
    private var mainController: NSWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //        window = NSWindow(contentRect: NSMakeRect(10, 10, 300, 300), styleMask: [.miniaturizable, .closable, .resizable, .titled], backing: .buffered, defer: false)
        //        window?.center()
        //        window?.makeKeyAndOrderFront(nil)
        //
        ////        window!.setFrameOriginToPositionWindowInCenterOfScreen()
        //        controller = ViewController()
        //        let content = window!.contentView! as NSView
        //        let view = controller!.view
        //        content.addSubview(view)
        
        /// https://gist.github.com/lucamarrocco/2b06c92e4e6df01de04b
        let mainMenu = NSMenu()
        let mainMenuFileItem = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
        let fileMenu = NSMenu(title: "File")
        //fileMenu.addItem(withTitle: "Quit", action: #selector(NSApp.terminate), keyEquivalent: "q")
        fileMenu.addItem(withTitle: "Quit", action: #selector(quit(sender:)), keyEquivalent: "q")
        mainMenuFileItem.submenu = fileMenu
        mainMenu.addItem(mainMenuFileItem)
        NSApp.mainMenu = mainMenu
        
        let window = NSWindow(contentRect: NSMakeRect(0, 0, 600, 300),
                              styleMask:[.titled, .closable, .miniaturizable, .resizable],
                              backing: .buffered,
                              defer: false)
        
        
        window.center()
        //window.setFrameOriginToPositionWindowInCenterOfScreen()
        
        //window.backgroundColor = NSColor(calibratedRed: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        window.title = "App"
        
        window.orderFrontRegardless()
        //window.makeKeyAndOrderFront(nil)
        
        //window.appearance = NSAppearance.current
        
        mainWindow = window
        
        let windowController = WindowController(window: window)
        windowController.showWindow(window)
        mainController = windowController
        
        let controller = ViewController()
        self.controller = controller
        window.contentViewController = controller
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ app: NSApplication) -> Bool{
        return true
    }
}
extension NSWindow {
    public func setFrameOriginToPositionWindowInCenterOfScreen() {
        if let screenSize = screen?.frame.size {
            self.setFrameOrigin(NSPoint(x: (screenSize.width-frame.size.width)/2, y: (screenSize.height-frame.size.height)/2))
        }
    }
}

extension AppDelegate {
    @objc func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}



import Cocoa

final class ViewController: NSViewController {
    override func loadView() {
        let view = NSView(frame: NSMakeRect(0,0,100,100))
        view.wantsLayer = true
        view.layer?.borderWidth = 2
        view.layer?.borderColor = NSColor.red.cgColor
        self.view = view
    }
}


final class WindowController: NSWindowController {
    
}
