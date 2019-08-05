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
        toolbar.displayMode = .default
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
    
    func imageButton() -> NSToolbarItem {
        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "screenshot"))
        item.label = "screenshot"
        item.paletteLabel = "screenshot"
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
    
    @objc private func screenshotAction() {
        
    }
    
    func segmentedControl() -> NSToolbarItemGroup {
        let itemGroup = NSToolbarItemGroup(itemIdentifier: .screenOption)
        
        let control = NSSegmentedControl(frame: NSRect(x: 0, y: 0, width: 100, height: 40))
        control.segmentStyle = .texturedSquare
        if #available(OSX 10.10.3, *) {
            control.trackingMode = .momentary
        } else {
            // Fallback on earlier versions
        }
//        control.segmentCount = group.count
        control.focusRingType = .none
//        control.tag = tag.rawValue
        
        var items = [NSToolbarItem]()
        var iSeg = 0
//        for segment in group {
//            let item = NSToolbarItem(itemIdentifier: segment.identifier)
//            items.append(item)
//            item.label = segment.label
//            item.tag = segment.tag.rawValue
//            item.action = action
//            item.target = target
//            control.action = segment.action // button & container send to separate handlers
//            control.target = segment.target
//            control.setImage(segment.image, forSegment: iSeg)
//            control.setImageScaling(.scaleProportionallyDown, forSegment: iSeg)
//            control.setWidth(segment.width, forSegment: iSeg)
//            control.setTag(segment.tag.rawValue, forSegment: iSeg)
//            iSeg += 1
//        }
//        itemGroup.paletteLabel = paletteLabel
        itemGroup.subitems = items
        itemGroup.view = control
        return itemGroup
    }
}


extension ToolbarManager: NSToolbarDelegate {
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.screenshot]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.screenshot]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        switch itemIdentifier {
        case .screenshot:
            return imageButton()
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
}

extension NSToolbar.Identifier {
    static let main = "Main"
}
