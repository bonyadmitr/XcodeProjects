import Cocoa

final class MenuManager {
    
    //static let shared = MenuManager()
    
    private let mainMenu = NSMenu(title: "Main")
    
    func setup() {
        /// first menu is hidden under app name
        addAppMenu()
        addEditMenu()
        addWindowMenu()
        
        /// call the last to add system hidden items like emojy
        NSApp.mainMenu = mainMenu
    }
    
    private func addAppMenu() {
        let appMenu = NSMenu(title: "App")
        
        
        appMenu.addItem(withTitle: "About",
                        action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
                        keyEquivalent: "a")
            .keyEquivalentModifierMask = [.option, .shift]
        
        appMenu.addItem(NSMenuItem.separator())
        
        //appMenu.addItem(withTitle: "Hide \(App.name)", action: #selector(NSApp.hide(_:)), keyEquivalent: "h")
        
        appMenu.addItem(withTitle: "Hide Others",
                        action: #selector(NSApp.hideOtherApplications(_:)),
                        keyEquivalent: "")
            .keyEquivalentModifierMask = [.option, .command]
        
        appMenu.addItem(withTitle: "Show all", action: #selector(NSApp.unhideAllApplications(_:)), keyEquivalent: "")
        
        appMenu.addItem(NSMenuItem.separator())
        
        appMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        
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
        selectAllMenuItem.action = #selector(NSTableView.selectAll(_:))
        editMenu.addItem(selectAllMenuItem)
        
        let copyAllMenuItem = NSMenuItem()
        copyAllMenuItem.title = "Copy"
        copyAllMenuItem.keyEquivalent = "c"
        
        copyAllMenuItem.action = NSSelectorFromString("copy:")//#selector(ViewController.copy1)
        //copyAllMenuItem.keyEquivalentModifierMask = .command
        editMenu.addItem(copyAllMenuItem)

//            editMenu.addItem(withTitle: "About 2", action: #selector(about), keyEquivalent: "x").target = self
        
        mainMenu.addSubmenu(menu: editMenu)
    }
    
    private func addWindowMenu() {
        let windowMenu = NSMenu(title: "Window")
        
        windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m")
        windowMenu.addItem(withTitle: "Zoom", action: #selector(NSWindow.zoom(_:)), keyEquivalent: "")
        windowMenu.addItem(withTitle: "Hide all", action: #selector(NSApp.hide(_:)), keyEquivalent: "h")
        
        mainMenu.addSubmenu(menu: windowMenu)
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
