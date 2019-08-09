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
    
    @objc private func screenshotAction() {
        QRService.scanDisplays()
    }
    
    @objc private func windowsAction() {
        QRService.scanWindows()
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
        return [.flexibleSpace, .screenOption, .flexibleSpace]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.screenOption, .screenshot, .windows, .space, .flexibleSpace]
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



//#if DEBUG
//if #available(OSX 10.12, *) {
//
//    let bytesInMegabyte = 1024.0 * 1024.0
//    let totalMemory = Double(System.memoryTotal) / bytesInMegabyte
//
//    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
//        let usedMemory = Double(System.memoryUsage()) / bytesInMegabyte
//        let memory = String(format: "%.1f of %.0f MB used", usedMemory, totalMemory)
//        print(String(format: "CPU: %.1f%%", System.cpuUsage()))
//        print(memory)
//        print()
//    }
//}
//#endif
struct System {
    
    static let osVersion: String = {
        
        let os = ProcessInfo.processInfo.operatingSystemVersion
        return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
    }()
    
    static let hardwareModel: String = {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        return String(cString: model)
    }()
    
    /// sysctl machdep.cpu
    /// "machdep.cpu" not working
    /// http://support.moonpoint.com/os/os-x/machdep_cpu.php
    ///
    /// https://stackoverflow.com/a/7379560/5893286
    static let cpuMainInfo: String = {
        var size = 0
        sysctlbyname("machdep.cpu.brand_string", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("machdep.cpu.brand_string", &model, &size, nil, 0)
        return String(cString: model)
    }()
    
    static let memoryTotal = ProcessInfo.processInfo.physicalMemory
    
    static func cpuUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList = UnsafeMutablePointer(mutating: [thread_act_t]())
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }
        
        if threadsResult == KERN_SUCCESS {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                
                guard infoResult == KERN_SUCCESS else {
                    break
                }
                
                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }
        
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        return totalUsageOfCPU
    }
    
    /// can be static
    static func memoryUsage() -> UInt64 {
        
        
        // TODO: check on device
        /// memory usage not equal Xcode Debug Gauge
        //        var taskInfo = mach_task_basic_info()
        //        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        //        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
        //            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
        //                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
        //            }
        //        }
        //
        //        var used: UInt64 = 0
        //        if result == KERN_SUCCESS {
        //            used = UInt64(taskInfo.resident_size)
        //        }
        
        /// resident_size does not get accurate memory, and the correct way is to use phys_footprint, which can be proved from the source codes of WebKit and XNU.
        /// https://github.com/WebKit/webkit/blob/master/Source/WTF/wtf/cocoa/MemoryFootprintCocoa.cpp
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }
        
        return used
    }
    
    static func defalutBrowserBundleId() -> String {
        return (LSCopyDefaultHandlerForURLScheme("https" as CFString)?.takeRetainedValue() as String?)
            .assert(or: "")
    }
    
    /// https://stackoverflow.com/a/931277/5893286
    static func allBrowsersBundleIds() -> [String] {
        /// addition "com.apple.Notes", there is no "org.mozilla.firefox"
        //return (LSCopyAllRoleHandlersForContentType("public.html" as CFString, .viewer)?.takeRetainedValue() as? [String]).assert(or: [])
        /// addition "com.rockysandstudio.MKPlayer"
        return (LSCopyAllHandlersForURLScheme("https" as CFString)?.takeRetainedValue() as? [String]).assert(or: [])
    }
}

extension Optional {
    func assert(or defaultValue: Wrapped) -> Wrapped {
        switch self {
        case .none:
            assertionFailure()
            return defaultValue
        case .some(let value):
            return value
        }
    }
}
