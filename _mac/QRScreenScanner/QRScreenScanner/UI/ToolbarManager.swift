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
        QRService.scanWindows()
    }
    
    @objc private func browserAction() {
        QRService.scanBrowser()
    }
    
    @objc private func deleteAllAction() {
        UserDefaults.standard.removeObject(forKey: "historyDataSource")
        //UserDefaults.standard.set([], forKey: "historyDataSource")
    }
    
    private func scanOptionsItem() -> NSToolbarItemGroup {
        let itemGroup = ToolbarItemGroup(itemIdentifier: .scanOptions, items: [screenshotItem(), windowsItem(), browserItem()], itemsWidth: 70)
        itemGroup.actionsTarget = self
        return itemGroup
    }
}

extension ToolbarManager: NSToolbarDelegate {
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.flexibleSpace, .scanOptions, .flexibleSpace, .deleteAll]
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
