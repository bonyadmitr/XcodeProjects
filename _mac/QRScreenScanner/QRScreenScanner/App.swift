import Cocoa

// TODO: dock manager
// TODO: https://stackoverflow.com/a/9220857/5893286
// TODO: https://stackoverflow.com/a/50832237/5893286 + https://stackoverflow.com/a/4686782/5893286
// TODO: https://developer.apple.com/library/archive/technotes/tn2083/_index.html

// TODO: drag and drop image
// TODO: multi selection + action
// TODO: feedback button

// TODO: view bases tableview
// TODO: delete button in table
// TODO: multiline text

// TODO: clear controller

// TODO: Quick Alert nothing found
// TODO: Add contact from qr
// TODO: Icon
// TODO: Status icon

final class App {
    
    static let shared = App()
    
    let statusItemManager = StatusItemManager()
    let menuManager = MenuManager()
    let toolbarManager = ToolbarManager()
    
    private let window: NSWindow = {
        let vc = ViewController()
        let window = NSWindow(contentRect: vc.view.frame,
                              styleMask: [.titled, .closable, .miniaturizable, .resizable],
                              backing: .buffered,
                              defer: true)
        window.title = App.name
        window.contentViewController = vc
        window.center()
        /// call it after .center()
        window.setFrameAutosaveName("MainWindow")
        return window
    }()
    
    func start() {
        menuManager.setup()
        statusItemManager.setup()
        toolbarManager.addToWindow(window)
        showWindow()
    }
    
    func showWindow() {
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

extension App {
    static let id = Bundle.main.bundleIdentifier.assert(or: "")
    static let name = (Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String).assert(or: "")
    static let version = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String).assert(or: "")
    static let build = (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String).assert(or: "")
    static let versionWithBuild = "\(version) (\(build))"
    
    static func openSubmitFeedbackPage() {
        let feedbackBody =
        """
        qwe
        <!--
        Provide your feedback here. Include as many details as possible.
        You can also email me at bonyadmitr@gmail.com
        -->
        
        ---
        \(App.name) \(App.versionWithBuild)
        macOS \(System.osVersion)
        \(System.hardwareModel)
        """
        
        guard
            let encodedBody = feedbackBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            /// can be added title: "&title=\(title)"
            let url = URL(string: "https://github.com/bonyadmitr/XcodeProjects/issues/new?body=\(encodedBody)")
        else {
            assertionFailure()
            return
        }
        
        NSWorkspace.shared.open(url)
    }
}

import Cocoa

/// https://stackoverflow.com/a/34278766/5893286
/// https://stackoverflow.com/a/45518276/5893286
/// https://www.raywenderlich.com/1016-drag-and-drop-tutorial-for-macos
/// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/DragandDrop/Tasks/DraggingFiles.html
class DropView: NSView {
    
    private var fileTypes = [String]()
    
    private var handler: ((_ paths: [String]) -> Void)?
    
    func setup(fileTypes: [String], handler: @escaping (_ paths: [String]) -> Void) {
        self.fileTypes = fileTypes
        self.handler = handler
        startDraggind()
    }
    
    func startDraggind() {
        registerForDraggedTypes([.backwardsCompatibleFileURL])
    }
    
    func stopDraggin() {
        unregisterDraggedTypes()
    }
    
    private var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if isReceivingDrag {
            NSColor.selectedControlColor.set()
            let path = NSBezierPath(rect: bounds)
            path.lineWidth = 8
            path.stroke()
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let isAllowed = isAllowedExtension(in: sender)
        isReceivingDrag = isAllowed
        return isAllowed ? .copy : NSDragOperation()//[]
    }
    
    private lazy var filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes: fileTypes]
    
    fileprivate func isAllowedExtension(in sender: NSDraggingInfo) -> Bool {
        return sender.draggingPasteboard.canReadObject(forClasses: [NSURL.self], options: filteringOptions)
        
//        var canAccept = false
//
//        //2.
//        let pasteBoard = sender.draggingPasteboard
//        //let q = NSURL(from: pasteBoard)
//        //3.
//        if pasteBoard.canReadObject(forClasses: [NSURL.self], options: filteringOptions) {
//            canAccept = true
//        }
////        else if let types = pasteBoard.types, nonURLTypes.intersection(types).count > 0 {
////            canAccept = true
////        }
//        return canAccept
        
        
        /// readObjects https://stackoverflow.com/a/51344295/5893286
//        guard let dropUrls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self],options: nil) as? [URL] else {
//            return false
//        }
//        let dropFileExtensions = dropUrls.map { $0.pathExtension }
//
//        /// or #1. if one file is allowed, will allow drop
//        for fileExtension in dropFileExtensions {
//            if allowedExtensions.contains(where: { $0.caseInsensitiveCompare(fileExtension) == .orderedSame }) {
//                return true
//            }
//        }
//        return false
        
        /// or #2. if one file is not allowed, will not allow drop
        //for fileExtension in fileExtensions {
        //    if !allowedExtensions.contains(where: { $0.caseInsensitiveCompare(fileExtension) == .orderedSame }) {
        //        return false
        //    }
        //}
        //return true
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return isAllowedExtension(in: sender)
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        /// Convert the window-based coordinate to a view-relative coordinate
        /// start from left-bottom corner
        //let point = convert(sender.draggingLocation, from: nil)
        //print(point)
        
        guard let urls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: filteringOptions) as? [URL] else {
            assertionFailure()
            return false
        }
        assert(!urls.isEmpty, "one url must exists here")
        let paths = urls.map { $0.path }
//            .filter { url in
//                fileTypes.contains(where: {
//                    $0.caseInsensitiveCompare(url.pathExtension) == .orderedSame
//                })
//            }.map { $0.path }
        handler?(paths)
        return true
    }
    
//    override func draggingExited(_ sender: NSDraggingInfo?) {
//    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        isReceivingDrag = false
    }
}

extension NSPasteboard.PasteboardType {
    
    /// https://stackoverflow.com/a/46514780/5893286
    static let backwardsCompatibleFileURL: NSPasteboard.PasteboardType = {
        //return NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")
        if #available(OSX 10.13, *) {
            return .fileURL
            //return .URL
        } else {
            return NSPasteboard.PasteboardType(kUTTypeFileURL as String)
            //return NSPasteboard.PasteboardType(kUTTypeURL as String)
        }
    }()
    
}
