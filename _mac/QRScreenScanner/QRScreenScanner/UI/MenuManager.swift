import Cocoa

final class MenuManager {
    
    //static let shared = MenuManager()
    
    private let mainMenu = NSMenu(title: "Main")
    
    func setup() {
        /// first menu is hidden under app name
        addAppMenu()
        
        //testMenu()
        
        /// call the last to add system hidden items like emojy
        NSApp.mainMenu = mainMenu
    }
    
    private func addAppMenu() {
        let appMenu = NSMenu(title: "App")
        
        appMenu.addItem(withTitle: "About",
                        action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
                        keyEquivalent: "a")//.target = NSApp
        
        appMenu.addItem(withTitle: "Quit",
                        action: #selector(NSApplication.terminate(_:)),
                        keyEquivalent: "q")
        
        mainMenu.addSubmenu(menu: appMenu)
    }
    
    //    private func testMenu() {
    //        let editMenu = mainMenu.createSubmenu(title: "Edit")
    //        //editMenu.autoenablesItems = false
    //
    //        let aboutMenuItem = NSMenuItem(title: "About 1", action: #selector(about), keyEquivalent: "z")
    //        aboutMenuItem.target = self
    //        editMenu.addItem(aboutMenuItem)
    //
    //        editMenu.addItem(withTitle: "About 2", action: #selector(about), keyEquivalent: "x").target = self
    //    }
    //
    //    @objc private func quit() {
    //        NSApp.terminate(nil)
    //    }
    //
    //    @objc private func about() {
    //        NSApp.orderFrontStandardAboutPanel(self)
    //    }
}

extension NSMenu {
    
    /// for title "Edit" will add emojy menuItem. it bcz of `addItem(withTitle: "Edit"`.
    /// setSubmenu must be called before `NSApp.mainMenu = mainMenu` to add emojy menuItem.
    func createSubmenu(title: String) -> NSMenu {
        let menu = NSMenu(title: title)
        let menuItem = addItem(withTitle: title, action: nil, keyEquivalent: "")
        setSubmenu(menu, for: menuItem)
        return menu
    }
    
    func addSubmenu(menu: NSMenu) {
        let menuItem = addItem(withTitle: menu.title, action: nil, keyEquivalent: "")
        setSubmenu(menu, for: menuItem)
    }
}
