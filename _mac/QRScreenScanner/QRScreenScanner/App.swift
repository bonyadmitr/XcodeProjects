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
    
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        toolbar.allowsUserCustomization = true
        toolbar.displayMode = .iconAndLabel
        toolbar.delegate = self
        
        // TODO: toolbar.autosavesConfiguration = true
        
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

// TODO: without "itemsWidth". fit width for any localization
/// https://christiantietze.de/posts/2018/11/reliable-nssegmentedcontrol-in-toolbar/
///
/// new api
/// https://github.com/peteog/Samples/blob/master/macOS/NSToolbarSegments/NSToolbarSegments/MainWindowController.swift
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

//final class ToolbarItemGroup2: NSToolbarItemGroup {
//
//    let control = NSSegmentedControl()
//
//    var selectedSegment: Int {
//        get { return control.selectedSegment }
//        set { control.selectedSegment = newValue }
//    }
//
//    convenience init(itemIdentifier: NSToolbarItem.Identifier, images: [NSImage], labels: [String], itemsWidth: CGFloat) {
//        self.init(itemIdentifier: itemIdentifier)
//        control.trackingMode = .momentary
//        control.segmentStyle = .texturedSquare
//        control.focusRingType = .none
//        control.segmentCount = images.count
////        control.target = self
////        control.action = #selector(segmentAction)
//
//        for (i, image) in images.enumerated() {
//            control.setImage(image, forSegment: i)
//            control.setImageScaling(.scaleProportionallyDown, forSegment: i)
//            control.setLabel(labels[i], forSegment: i)
//            control.setWidth(itemsWidth, forSegment: i)
//        }
//
//        view = control
////        subitems = items
//    }
//}

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
        
        return nil
    }
}

private extension NSToolbarItem.Identifier {
    static let screenOption = NSToolbarItem.Identifier("screenOption")
    static let screenshot = NSToolbarItem.Identifier("screenshot")
    static let windows = NSToolbarItem.Identifier("windows")
}

private extension NSToolbar.Identifier {
    static let main = "Main"
}
