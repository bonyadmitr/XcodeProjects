import Cocoa

private extension NSToolbarItem.Identifier {
    static let screenOption = NSToolbarItem.Identifier("screenOption")
    static let screenshot = NSToolbarItem.Identifier("screenshot")
    static let windows = NSToolbarItem.Identifier("windows")
    static let browser = NSToolbarItem.Identifier("browser")
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
    
    func screenshotItem() -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier: .screenshot,
                             label: "Screenshot",
                             image: NSImage(named: NSImage.flowViewTemplateName),
                             target: self,
                             action: #selector(screenshotAction))
    }
    
    func windowsItem() -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier: .windows,
                             label: "Windows",
                             image: NSImage(named: NSImage.iconViewTemplateName),
                             target: self,
                             action: #selector(windowsAction))
    }
    
    func browserItem() -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier: .windows,
                             label: "Browser",
                             image: NSImage(named: NSImage.networkName),
                             target: self,
                             action: #selector(windowsAction))
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
    
    func segmentedControl() -> NSToolbarItemGroup {
        let itemGroup = ToolbarItemGroup(itemIdentifier: .screenOption, items: [screenshotItem(), windowsItem(), browserItem()], itemsWidth: 70)
        itemGroup.actionsTarget = self
        return itemGroup
    }
}

extension ToolbarManager: NSToolbarDelegate {
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.flexibleSpace, .screenOption, .flexibleSpace]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.screenOption, .screenshot, .windows, .browser, .space, .flexibleSpace]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        switch itemIdentifier {
        case .screenshot:
            return screenshotItem()
        case .windows:
            return windowsItem()
        case .screenOption:
            return segmentedControl()
        case .browser:
            return browserItem()
        default:
            assertionFailure()
        }
        
        return nil
    }
}
