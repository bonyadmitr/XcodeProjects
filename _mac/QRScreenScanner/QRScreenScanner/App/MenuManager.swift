import Cocoa

final class MenuManager {
    
    //static let shared = MenuManager()
    
    private let mainMenu = NSMenu(title: "Main")
    
    func setup() {
        /// first menu is hidden under app name
        addAppMenu()
        addEditMenu()
        
        /// call the last to add system hidden items like emojy
        NSApp.mainMenu = mainMenu
    }
    
    private func addAppMenu() {
        let appMenu = NSMenu(title: "App")
        
        appMenu.addItem(withTitle: "About",
                        action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
                        keyEquivalent: "a").keyEquivalentModifierMask = [.option, .shift]
        
        appMenu.addItem(withTitle: "Quit",
                        action: #selector(NSApplication.terminate(_:)),
                        keyEquivalent: "q")
        
        mainMenu.addSubmenu(menu: appMenu)
    }
    
    let deleteMenuItem = NSMenuItem()
    let selectAllMenuItem = NSMenuItem()
    
    private func addEditMenu() {
        let editMenu = NSMenu(title: "Edit")
        //editMenu.autoenablesItems = false

        let deleteKey = String(format: "%c", NSBackspaceCharacter)
        //let deleteKey = String(Character(UnicodeScalar(NSBackspaceCharacter)!))
        
        deleteMenuItem.title = "Delete"
        deleteMenuItem.keyEquivalent = deleteKey
        deleteMenuItem.keyEquivalentModifierMask = .command
//            aboutMenuItem.target = self
//            aboutMenuItem.action =
        editMenu.addItem(deleteMenuItem)
        
        
        selectAllMenuItem.title = "Select all"
        selectAllMenuItem.keyEquivalent = "a"
        selectAllMenuItem.keyEquivalentModifierMask = .command
        editMenu.addItem(selectAllMenuItem)

//            editMenu.addItem(withTitle: "About 2", action: #selector(about), keyEquivalent: "x").target = self
        
        mainMenu.addSubmenu(menu: editMenu)
    }
    
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
