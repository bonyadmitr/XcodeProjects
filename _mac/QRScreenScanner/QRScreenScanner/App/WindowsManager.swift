import Cocoa

final class WindowsManager: NSObject {
    
    /// UndoManager created in window automaticaly.
    /// pass it in NSWindowDelegate windowWillReturnUndoManager
    //private let undoManager = UndoManager()
    
//    override init() {
//        super.init()
//    }
    
    /// if it is not lazy controller will be loaded immediately
    ///
    /// window style https://lukakerr.github.io/swift/nswindow-styles
    lazy var window: Window = {
        let vc = ViewController()
        let window = Window(vc: vc)
        window.title = App.name
        
        /// animation not always work for start window
        window.animationBehavior = .none
        
        /// https://stackoverflow.com/a/42984241/5893286
        /// when the window is the full size cost more memory
        window.contentView?.wantsLayer = true
        
        window.center()
        /// call it after .center()
        window.setFrameAutosaveName("MainWindow")
        
        window.delegate = self
        return window
    }()
    
    func showWindow() {
        //window.orderFront(nil)
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

extension WindowsManager: NSWindowDelegate {
    
    func window(_ window: NSWindow, willPositionSheet sheet: NSWindow, using rect: NSRect) -> NSRect {
        
        if let window = window as? Window,
            window.hideToolbarCustomizationPaletteItems,
            sheet.className == "NSToolbarConfigPanel"
        {
            removeSizeAndDisplayMode(in: sheet)
        }
        
        return rect
    }
    
    //func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager? {
    //    return undoManager
    //}
    
    /// problem https://stackoverflow.com/a/16027120/5893286
    //func window(_ window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions = []) -> NSApplication.PresentationOptions {
    //    return [.fullScreen, .autoHideDock, .autoHideMenuBar, .autoHideToolbar]
    //}
    
    /// inspire by https://stackoverflow.com/a/39647181/5893286
    func removeSizeAndDisplayMode(in sheet: NSWindow) {
        
        sheet.contentView?.subviews.first?.subviews
            .first { $0 is NSStackView }?
            .subviews.first { $0 is NSStackView }?
            .isHidden = true
        
        // TODO: find out macOS version where window contains NSStackView
        //guard let views = sheet.contentView?.subviews else {
        //    assertionFailure()
        //    return
        //}
        //
        //// Hide Small Size Option
        //views
        //    .compactMap { $0 as? NSButton }
        //    .first { button -> Bool in
        //        guard let buttonTypeValue = button.cell?.value(forKey: "buttonType") as? UInt,
        //            let buttonType = NSButton.ButtonType(rawValue: buttonTypeValue)
        //            else { return false }
        //        return buttonType == .switch
        //    }?.isHidden = true
        //
        //// Hide Display Mode Option
        //views.first { $0.subviews.count == 2 }?.isHidden = true
        //
        //sheet.contentView?.needsDisplay = true
    }
}

final class Window: NSWindow {
    
    /// NSDocumentController.openDocument(_:)
    @objc private func openDocument(_ sender: Any?) {
        
        /// code https://stackoverflow.com/a/57391724/5893286
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.allowedFileTypes = NSImage.imageTypes
        
        /// not shown in NSOpenPanel
        //openPanel.title = "Select an image"
        
        openPanel.beginSheetModal(for: self) { response in
            
            /// same: response.rawValue == NSFileHandlingPanelOKButton
            if response == .OK {
                
                /// to fill Open Recent menu
                openPanel.urls.forEach { NSDocumentController.shared.noteNewRecentDocumentURL($0) }
                
                let filePaths = openPanel.urls.compactMap { $0.path }
                QRService.scanFiles(at: filePaths)
            }
            
            //openPanel.close()
        }

    }
    
    private var savedToolbarMenuItems = [NSMenuItem]()
    
    private lazy var customizationPaletteItems = [NSMenuItem(title: "Customize toolbar…", action: #selector(NSWindow.runToolbarCustomizationPalette(_:)), keyEquivalent: "")]
    
    private var toolbarMenuItems: NSMenu?
    
    /// set after window.toolbar set.
    /// inspire by https://stackoverflow.com/a/39647181/5893286
    var hideToolbarCustomizationPaletteItems = false {
        didSet {
            assert(toolbar != nil, "toolbar should be set")
            
            if hideToolbarCustomizationPaletteItems {
                removeIconCustomization()
            } else {
                restoreMenu()
            }
        }
    }
    
    override var toolbar: NSToolbar? {
        didSet {
            guard let contextMenu = contentView?.superview?.menu else {
                assertionFailure()
                return
            }
            
            toolbarMenuItems = contextMenu
            savedToolbarMenuItems = contextMenu.items
            
            //customizationPaletteItem = NSMenuItem(title
            
            //customizationPaletteItem = contextMenu.items.last
            
            //customizationPaletteItem = contextMenu.items.first(where: { $0.action == #selector(NSWindow.runToolbarCustomizationPalette(_:)) })
        }
    }
    
    /// call after window.toolbar set.
    private func removeIconCustomization() {
        assert(toolbar != nil, "toolbar should be set")
        
//        guard let contextMenu = contentView?.superview?.menu else {
//            assertionFailure()
//            return
//        }
        
//        savedToolbarMenuItems = contextMenu.items
        
        /// or #1
        //let customizationPaletteItem = NSMenuItem(title: "Customize toolbar…", action: #selector(NSWindow.runToolbarCustomizationPalette(_:)), keyEquivalent: "")
        
        /// or #2
        //        guard
        //            let customizationPaletteItem = contextMenu.items.first(where: { $0.action == #selector(NSWindow.runToolbarCustomizationPalette(_:)) })
        //        else {
        //            assertionFailure()
        //            return
        //        }
        
        /// or #a
//        contextMenu.items = [customizationPaletteItem]
        
        //contentView?.superview?.menu?.items = [customizationPaletteItem]
        toolbarMenuItems?.items = customizationPaletteItems
        
        /// or #b
        //        contextMenu.items
        //            .filter { $0.action != #selector(NSWindow.runToolbarCustomizationPalette(_:)) }
        //            .forEach { contextMenu.removeItem($0) }
    }
    
    /// call after window.toolbar set.
    private func restoreMenu() {
        assert(toolbar != nil, "toolbar should be set")
        //contentView?.superview?.menu?.items = savedToolbarMenuItems
        toolbarMenuItems?.items = savedToolbarMenuItems
    }
}


private extension NSWindow {
    
    /// same as self.init(contentViewController: vc)
    convenience init(vc: NSViewController) {
        self.init(contentRect: vc.view.frame,
                  styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                  backing: .buffered,
                  defer: false)
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

extension NSSavePanel {
    func beginSheetModal(for window: NSWindow?, completionHandler handler: @escaping (NSApplication.ModalResponse) -> Void) {
        if let window = window {
            beginSheetModal(for: window, completionHandler: handler)
        } else {
            begin(completionHandler: handler)
        }
    }
}
