import Cocoa

private extension NSToolbarItem.Identifier {
    static let scanOptions = NSToolbarItem.Identifier("scanOptions")
    static let scanScreenshot = NSToolbarItem.Identifier("scanScreenshot")
    static let scanWindows = NSToolbarItem.Identifier("scanWindows")
    static let scanBrowser = NSToolbarItem.Identifier("scanBrowser")
    static let deleteAll = NSToolbarItem.Identifier("deleteAll")
}

private extension NSToolbar.Identifier {
    static let main = "Main"
}


// TODO: without "itemsWidth". fit width for any localization
/// https://christiantietze.de/posts/2018/11/reliable-nssegmentedcontrol-in-toolbar/
///
/// new api
/// https://github.com/peteog/Samples/blob/master/macOS/NSToolbarSegments/NSToolbarSegments/MainWindowController.swift
///
/// https://stackoverflow.com/a/55883314/5893286
///
/// system images
/// https://developer.apple.com/design/human-interface-guidelines/macos/icons-and-images/system-icons/
///
/// after adding items in edit mode there will be layout error "Unable to simultaneously satisfy constraints"
final class ToolbarManager: NSObject {
    
    private let toolbar = NSToolbar(identifier: .main)
    
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        toolbar.delegate = self
        toolbar.autosavesConfiguration = true
        toolbar.allowsUserCustomization = true
        toolbar.displayMode = .iconAndLabel
        
        //if #available(OSX 10.14, *) {
        //toolbar.centeredItemIdentifier = .screenOption
    }
    
    func addToWindow(_ window: NSWindow) {
        window.toolbar = toolbar
//        removeIconCustomization(for: window)
    }
    
    private var savedToolbarMenuItems = [NSMenuItem]()
    
    /// call after window.toolbar set.
    /// code https://stackoverflow.com/a/39647181/5893286
    private func removeIconCustomization(for window: NSWindow) {
        
        guard let contextMenu = window.contentView?.superview?.menu else {
            assertionFailure()
            return
        }
        
        savedToolbarMenuItems = contextMenu.items
        
        /// or #1
        let customizationPaletteItem = NSMenuItem(title: "Customize toolbar…", action: #selector(NSWindow.runToolbarCustomizationPalette(_:)), keyEquivalent: "")
        
        /// or #2
//        guard
//            let customizationPaletteItem = contextMenu.items.first(where: { $0.action == #selector(NSWindow.runToolbarCustomizationPalette(_:)) })
//        else {
//            assertionFailure()
//            return
//        }
        
        /// or #a
        contextMenu.items = [customizationPaletteItem]
        
        /// or #b
//        contextMenu.items
//            .filter { $0.action != #selector(NSWindow.runToolbarCustomizationPalette(_:)) }
//            .forEach { contextMenu.removeItem($0) }
    }
    
    /// call after window.toolbar set.
    private func restoreMenu() {
        App.shared.windowsManager.window.contentView?.superview?.menu?.items = savedToolbarMenuItems
    }
    
    private func screenshotItem() -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier: .scanScreenshot,
                             label: "Screenshot",
                             image: NSImage(named: NSImage.flowViewTemplateName),
                             target: self,
                             action: #selector(screenshotAction))
    }
    
    private func windowsItem() -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier: .scanWindows,
                             label: "Windows",
                             image: NSImage(named: NSImage.iconViewTemplateName),
                             target: self,
                             action: #selector(windowsAction))
    }
    
    private func browserItem() -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier: .scanBrowser,
                             label: "Browser",
                             image: NSImage(named: NSImage.networkName),
                             target: self,
                             action: #selector(browserAction))
    }
    
    private func deleteAllItem() -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier: .deleteAll,
                             label: "DeleteAll",
                             image: NSImage(named: NSImage.trashFullName),
                             target: self,
                             action: #selector(deleteAllAction))
    }
    
    @objc private func screenshotAction() {
        QRService.scanDisplays()
    }
    
    @objc private func windowsAction() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(windowsActionDelayed), object: nil)
        perform(#selector(windowsActionDelayed), with: nil, afterDelay: 0.1)
    }
    
    @objc private func windowsActionDelayed() {
        QRService.scanWindows()
    }
    
    @objc private func browserAction() {
        QRService.scanBrowser()
    }
    
    @objc private func deleteAllAction() {
        HistoryDataSource.shared.history = []
    }
    
    private func scanOptionsItem() -> NSToolbarItemGroup {
        let itemGroup = ToolbarItemGroup(itemIdentifier: .scanOptions, items: [screenshotItem(), windowsItem(), browserItem()], itemsWidth: 70)
        itemGroup.actionsTarget = self
        return itemGroup
    }
}

extension ToolbarManager: NSToolbarDelegate {
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.space, .flexibleSpace, .scanOptions, .flexibleSpace, .deleteAll]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.scanOptions, .scanScreenshot, .scanWindows, .scanBrowser, .deleteAll, .space, .flexibleSpace]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        switch itemIdentifier {
        case .scanScreenshot:
            return screenshotItem()
        case .scanWindows:
            return windowsItem()
        case .scanOptions:
            return scanOptionsItem()
        case .scanBrowser:
            return browserItem()
        case .deleteAll:
            return deleteAllItem()
        default:
            assertionFailure()
        }
        
        return nil
    }
}

/// https://stackoverflow.com/a/51601171/5893286
extension NSSound.Name {
    static let basso     = NSSound.Name("Basso")
    static let blow      = NSSound.Name("Blow")
    static let bottle    = NSSound.Name("Bottle")
    static let frog      = NSSound.Name("Frog")
    static let funk      = NSSound.Name("Funk")
    static let glass     = NSSound.Name("Glass")
    static let hero      = NSSound.Name("Hero")
    static let morse     = NSSound.Name("Morse")
    static let ping      = NSSound.Name("Ping")
    static let pop       = NSSound.Name("Pop")
    static let purr      = NSSound.Name("Purr")
    static let sosumi    = NSSound.Name("Sosumi")
    static let submarine = NSSound.Name("Submarine")
    static let tink      = NSSound.Name("Tink")
}

/// work in background
extension NSSound {
    
    /// system error sound
    static func playError() {
        /// or #1
        NSSound.beep()
        /// or #2
        //NSSound(named: .funk)?.play()
    }
    
    static func playSuccess() {
        NSSound(named: .glass)?.play()
    }
}

/// need for AudioServicesPlaySystemSound
//import AudioToolbox

//func playSound() {
//    /// phone beep 1200 - 1211
//    AudioServicesPlaySystemSound(1209)
//
//    //        AudioServicesPlaySystemSound(1263)
//    //        AudioServicesPlaySystemSound(1264)
//    //        AudioServicesPlaySystemSound(1265)
//
//    //30-40 phone busy
//    //1-30 finder sounds
//
//    /// to test sounds in range
//    //        for i in 0...100 {
//    //            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
//    //                AudioServicesPlaySystemSound(SystemSoundID(0 + i))
//    //                print(i)
//    //            }
//    //        }
//}
