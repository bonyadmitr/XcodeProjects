import Cocoa

// TODO: dock manager
// TODO: https://stackoverflow.com/a/9220857/5893286
// TODO: https://stackoverflow.com/a/50832237/5893286 + https://stackoverflow.com/a/4686782/5893286
// TODO: https://developer.apple.com/library/archive/technotes/tn2083/_index.html

// TODO: fix horizonal scroll
// TODO: saving window size

final class App {
    
    static let shared = App()
    
    let statusItemManager = StatusItemManager()
    let menuManager = MenuManager()
    let toolbarManager = ToolbarManager()
    
    private let window: NSWindow = {
        let window = NSWindow(contentViewController: ViewController())
        window.center()
        return window
    }()
    
    func start() {
        //        ScreenManager.disableHardwareMirroring()
        //        ScreenManager.allDisplayImages()
        //        ScreenManager.toggleMirroring()
        
        //        let window = ScreenManager.compositedWindow(for: "Google Chrome")
        //        let w = ScreenManager.compositedWindowsByName()
        //let e = ScreenManager.windowsByName()
        //ScreenManager.visibleWindowsImages()
        
        
        menuManager.setup()
        statusItemManager.setup()
        showWindow()
        
        toolbarManager.addToWindow(window)
    }
    
    
    
    func showWindow() {
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

/// https://stackoverflow.com/a/55883314/5893286
final class ToolbarManager: NSObject {
    private let toolbar = NSToolbar(identifier: .main)
    
    let titles = ["Screenshot all displays", "All windows"]
    var selectedIndex = 0
    
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        toolbar.allowsUserCustomization = true
        toolbar.displayMode = .iconAndLabel
        toolbar.delegate = self
        if #available(OSX 10.14, *) {
            toolbar.centeredItemIdentifier = .screenOption
        } else {
            // Fallback on earlier versions
        }
    }
    
    func addToWindow(_ window: NSWindow) {
        window.toolbar = toolbar
    }
    
    func screenshotItem() -> NSToolbarItem {
        let item = NSToolbarItem(itemIdentifier: .screenshot)
        item.label = "Screenshot"
        item.paletteLabel = "Screenshot"
//        item.menuFormRepresentation = menuItem // Need this for text-only to work
//        item.tag = tag.rawValue
        
        
//        let button = NSButton(image: NSImage(named: NSImage.quickLookTemplateName)!, target: self, action: #selector(screenshotAction))
        let button = NSButton()
        //button.frame
        button.image = NSImage(named: NSImage.quickLookTemplateName)!
        button.target = self
        button.action = #selector(screenshotAction)
//        button.widthAnchor.constraint(equalToConstant: width).isActive = true
//        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.title = ""
        button.imageScaling = .scaleProportionallyDown
        button.bezelStyle = .texturedRounded
//        button.tag = tag.rawValue
        button.focusRingType = .none
        item.view = button
        return item
    }
    
    func windowsItem() -> NSToolbarItem {
        let image = NSImage(named: NSImage.quickLookTemplateName)!
        let button: NSButton
        if #available(OSX 10.12, *) {
            button = NSButton(image: image, target: self, action: #selector(screenshotAction))
        } else {
            button = NSButton()
            button.image = image
            button.target = self
            button.action = #selector(windowsAction)
        }

        button.title = ""
        button.imageScaling = .scaleProportionallyDown
        button.bezelStyle = .texturedRounded
        button.focusRingType = .none
        
        let item = NSToolbarItem(itemIdentifier: .windows)
        item.label = "Windows"
        item.paletteLabel = "Windows"
        item.view = button
        return item
    }
    
    @objc private func screenshotAction() {
        print("screenshotAction")
    }
    
    @objc private func windowsAction() {
        print("windowsAction")
    }
    
    func segmentedControl() -> NSToolbarItemGroup {
        let itemGroup = ToolbarItemGroup(itemIdentifier: .screenOption, items: [screenshotItem(), windowsItem()], itemsWidth: 70)
        itemGroup.actionsTarget = self
        return itemGroup
    }
}

final class ToolbarItemGroup: NSToolbarItemGroup {
    
    /// same that items target
    /// self.target will be overwrite by control.target after "view = control"
    var actionsTarget: AnyObject?
    
    convenience init(itemIdentifier: NSToolbarItem.Identifier, items: [NSToolbarItem], itemsWidth: CGFloat) {
        self.init(itemIdentifier: itemIdentifier)
        
        let control = NSSegmentedControl()
        
        ///if #available(OSX 10.10.3, *) {
        control.trackingMode = .momentary
        
        control.segmentStyle = .texturedSquare
        control.focusRingType = .none
        control.segmentCount = items.count
        control.target = self
        control.action = #selector(segmentAction)
        
        for (i, segment) in items.enumerated() {
            control.setImage(segment.image, forSegment: i)
            control.setImageScaling(.scaleProportionallyDown, forSegment: i)
            control.setWidth(itemsWidth, forSegment: i)
        }
        
        view = control
        subitems = items
    }
    
    @objc private func segmentAction(sender: NSSegmentedControl) {
        
        guard
            let item = subitems[safe: sender.selectedSegment],
            let action = item.action,
            let actionTarget = actionsTarget
        else {
            assertionFailure("Selected \(sender.selectedSegment) in \(subitems.count), target \(String(describing: self.actionsTarget))")
            return
        }
        
        NSApp.sendAction(action, to: actionTarget, from: nil)
    }
}

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}



extension ToolbarManager: NSToolbarDelegate {
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.screenOption]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.screenOption]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        switch itemIdentifier {
        case .screenshot:
            return screenshotItem()
        case .windows:
            return windowsItem()
        case .screenOption:
            return segmentedControl()
        default:
            assertionFailure()
        }
        
//        if itemIdentifier == .screenOption {
////            NSToolbarItemGroup(itemIdentifier: <#T##NSToolbarItem.Identifier#>)
////            let group = NSToolbarItemGroup(itemIdentifier: .screenOptionItem,
////                                           titles: titles,
////                                           selectionMode: .selectOne,
////                                           labels: nil,
////                                           target: self,
////                                           action: #selector(toolbarItemGroupSelectionChanged(_:)))
//            let group = NSToolbarItemGroup(itemIdentifier: .screenOption)
////            group.setSelected(true, at: 0)
//            return group
//        }
        
        return nil
    }
    
    // MARK: - Actions
    @objc private func toolbarItemGroupSelectionChanged(_ sender: NSToolbarItemGroup) {
//        selectedIndex = sender.selectedIndex
    }
}

extension NSToolbarItem.Identifier {
    static let screenOption = NSToolbarItem.Identifier("screenOption")
    static let screenshot = NSToolbarItem.Identifier("screenshot")
    static let windows = NSToolbarItem.Identifier("windows")
}

extension NSToolbar.Identifier {
    static let main = "Main"
}
