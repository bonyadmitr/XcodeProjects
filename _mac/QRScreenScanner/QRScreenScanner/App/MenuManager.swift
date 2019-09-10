import Cocoa

final class MenuManager {
    
    //static let shared = MenuManager()
    
    private let mainMenu = NSMenu(title: "Main")
    
    /// NiblessMenu project https://github.com/lapcat/NiblessMenu
    /// NiblessMenu post https://lapcatsoftware.com/articles/working-without-a-nib-part-10.html
    /// swift menu code https://github.com/LeafPlayer/Leaf/blob/7ded5d4676df4d1081c625cd951b63ceb699c20b/Leaf/MainMenu.swift
    /// objc menu https://github.com/lapcat/StopTheNews/blob/master/source/JJMainMenu.m
    /// links https://github.com/hammackj/niblesscocoa
    /// more at 'openRecentMenu'
    ///
    /// instead of .keyEquivalentModifierMask = [.shift, .command] use Uppercase letter
    func setup() {

        /// first menu is hidden under app name
        addAppMenu()
        addFileMenu()
        addEditMenu()
        addWindowMenu()
        addHelpMenu()
        
        /// call the last to add system hidden items like emojy
        //mainMenu.setValue("NSMainMenu", forKey: "menuName")
        NSApp.mainMenu = mainMenu
    }
    
    private func addAppMenu() {
        let menu = NSMenu(title: "App")
        //menu.setValue("NSAppleMenu", forKey: "menuName")
        
        /// doc https://developer.apple.com/documentation/appkit/nsapplication/aboutpaneloptionkey/2869609-credits
        /// Credits.rtf colors https://stackoverflow.com/a/56252527/5893286
        menu.addItem(withTitle: "About",
                        action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
                        keyEquivalent: "a")
            .keyEquivalentModifierMask = [.option, .shift]
        
        menu.addItem(NSMenuItem.separator())
        
//        let servicesMenu = NSMenu(title: "Services")
//        let servicesItem = menu.addItem(withTitle: "Services", action: nil, keyEquivalent: "")
//        servicesItem.submenu = servicesMenu
//
//        /// same servicesMenu.setValue("NSServicesMenu", forKey: "menuName")
//        NSApp.servicesMenu = servicesMenu
//
//        menu.addItem(NSMenuItem.separator())
        
        //appMenu.addItem(withTitle: "Hide \(App.name)", action: #selector(NSApp.hide(_:)), keyEquivalent: "h")
        
        menu.addItem(withTitle: "Hide Others",
                        action: #selector(NSApp.hideOtherApplications(_:)),
                        keyEquivalent: "")
            .keyEquivalentModifierMask = [.option, .command]
        
        menu.addItem(withTitle: "Show all", action: #selector(NSApp.unhideAllApplications(_:)), keyEquivalent: "")
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        
        mainMenu.addSubmenu(menu: menu)
    }
        
    private func addFileMenu() {
        let menu = NSMenu(title: "File")
        
        
        menu.addItem(withTitle: "Open…", action: #selector(NSDocumentController.openDocument(_:)), keyEquivalent: "o")
        
        /// should be called before applicationDidFinishLaunching.
        /// call in main.swift or applicationWillFinishLaunching.
        /// post http://lapcatsoftware.com/blog/2007/07/10/working-without-a-nib-part-5-open-recent-menu/
        /// using https://buckleyisms.com/blog/using-the-open-recent-menu-in-cocoa-without-nsdocument/
        let openRecentMenu = NSMenu(title: "Open Recent")
        openRecentMenu.setValue("NSRecentDocumentsMenu", forKey: "menuName")
//        openRecentMenu.perform(NSSelectorFromString("_setMenuName:"), with: "NSRecentDocumentsMenu")
        let menuItem = menu.addItem(withTitle: "Open Recent", action: nil, keyEquivalent: "")
        menuItem.submenu = openRecentMenu
        
        /// don't need for system openRecentMenu
        //openRecentMenu.addItem(.separator())
        //openRecentMenu.addItem(withTitle: "Clear Menu", action: #selector(NSDocumentController.clearRecentDocuments(_:)), keyEquivalent: "")
        
        
        mainMenu.addSubmenu(menu: menu)
    }
    
    private func addEditMenu() {
        let menu = NSMenu(title: "Edit")
        
        
        menu.addItem(withTitle: "Undo", action: #selector(EditMenuActions.undo(_:)), keyEquivalent: "z")

        menu.addItem(withTitle: "Redo", action: #selector(EditMenuActions.redo(_:)), keyEquivalent: "Z")
        
        // TODO: clear separator
        menu.addItem(.separator())
        
        menu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        
        menu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        
        menu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        
        //let backspaceChar = String(format: "%c", NSBackspaceCharacter)
        //let backspaceChar = String(Character(UnicodeScalar(NSBackspaceCharacter)!))
        let backspaceChar = "\u{8}"
        menu.addItem(withTitle: "Delete", action: #selector(NSText.delete(_:)), keyEquivalent: backspaceChar)
        
        menu.addItem(withTitle: "Select all", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        
        
        mainMenu.addSubmenu(menu: menu)
    }
    
    private func addWindowMenu() {
        let menu = NSMenu(title: "Window")
        
        
        menu.addItem(withTitle: "Minimize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m")
        
        menu.addItem(withTitle: "Zoom", action: #selector(NSWindow.zoom(_:)), keyEquivalent: "")
        
        menu.addItem(withTitle: "Enter full screen", action: #selector(NSWindow.toggleFullScreen(_:)), keyEquivalent: "f")
            .keyEquivalentModifierMask = [.control, .command]
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(withTitle: "Customize toolbar…", action: #selector(NSWindow.runToolbarCustomizationPalette(_:)), keyEquivalent: "")
        
        /// for automatic title change (Show/Hide) set "Show Toolbar" or "Hide Toolbar"
        menu.addItem(withTitle: "Show Toolbar", action:#selector(NSWindow.toggleToolbarShown(_:)), keyEquivalent:"t")
            .keyEquivalentModifierMask = [.command, .option]
        
        //menu.perform(NSSelectorFromString("_setMenuName:"), with: "NSWindowsMenu")
        NSApp.windowsMenu = menu
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(withTitle: "Hide all", action: #selector(NSApp.hide(_:)), keyEquivalent: "h")
        
        
        mainMenu.addSubmenu(menu: menu)
    }
    
    private func addHelpMenu() {
        /// adding menu with title "Help" adds Spotlight item
        let menu = NSMenu(title: "Help")
        
        /// add Spotlight item.
        /// set any menu to remove Spotlight item in "Help" menu
        NSApp.helpMenu = menu
        
        /// to remove Spotlight item in "Help" menu
//        NSApp.helpMenu = NSMenu()
        
        /// not working.
        /// NSApp.helpMenu doesn't set "menuName" of menu.
//        menu.setValue("_NSHelpMenu", forKey: "menuName")
//        menu.setValue("NSHelpMenu", forKey: "menuName")
//        menu.perform(NSSelectorFromString("_setMenuName:"), with: "_NSHelpMenu")
        
        menu.addItem(withTitle: "Documentation", action: #selector(openDocumentation), keyEquivalent: "").target = self
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(withTitle: "Release Notes", action: #selector(openReleaseNotes), keyEquivalent: "").target = self
        
        menu.addItem(withTitle: "Feedback and Bugs", action: #selector(openIssues), keyEquivalent: "").target = self
        
        /// "Submit feedback..."
        menu.addItem(withTitle: "Report an Issue", action: #selector(openSubmitFeedbackPage), keyEquivalent: "").target = self
        
        menu.addItem(withTitle: "Write E-mail", action: #selector(openEmail), keyEquivalent: "").target = self
        
        
        mainMenu.addSubmenu(menu: menu)
    }
    
    @objc private func openSubmitFeedbackPage() {
        App.openSubmitFeedbackPage()
    }
    
    @objc private func openReleaseNotes() {
        App.openReleaseNotes()
    }
    
    @objc private func openIssues() {
        App.openIssues()
    }
    
    @objc private func openDocumentation() {
        App.openDocumentation()
    }
    
    @objc private func openEmail() {
        App.sendEmailFeedback()
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


/// example https://medium.com/cocoaacademymag/undomanager-in-swift-5-with-simple-example-8c791e231b87
/// example https://samwize.com/2019/02/16/undomanager/
/// big example https://www.raywenderlich.com/5229-undomanager-tutorial-how-to-implement-with-swift-value-types
/// simple example https://stackoverflow.com/a/32596899/5893286
/// doc https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UndoArchitecture/UndoArchitecture.html
/// 
/// needs instead of NSSelectorFromString("undo:")
/// with '#selector(UndoManager.undo)' will not work undoManager.setActionName. it will be like any custom action
/// these aren't declared anywhere
@objc private protocol EditMenuActions {
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





/// You can find "systemMenu" in source of Main.storyboard

/// NSMainMenu
//NSApp.menu!.value(forKey: "menuName")

/// NSAppleMenu
//NSApp.menu!.items[0].submenu!.value(forKey: "menuName")

/// NSServicesMenu
//NSApp.menu!.items[0].submenu!.items[4].submenu!.value(forKey: "menuName")

/// NSFontMenu
//NSApp.menu!.items[3].submenu!.items[0].submenu!.value(forKey: "menuName")

/// _NSHelpMenu
//NSApp.menu!.items[6].submenu!.value(forKey: "menuName")

