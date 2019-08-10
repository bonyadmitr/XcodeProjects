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
//@available(OSX 10.13, *)
class DropView: NSView {
    
//    var filePath: String?
    let expectedExt = ["jpg", "jpeg", "bmp", "png", "gif"]  //file extensions allowed for Drag&Drop (example: "jpg","png","docx", etc..)
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
//        self.wantsLayer = true
//        self.layer?.backgroundColor = NSColor.gray.cgColor
        
        registerForDraggedTypes([.backwardsCompatibleFileURL])
//        registerForDraggedTypes([.URL, .fileURL])
    }
    
//    override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
//        // Drawing code here.
//    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
//            self.layer?.backgroundColor = NSColor.blue.cgColor
            return .copy
        } else {
            return []//NSDragOperation()
        }
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        
        guard let board = drag.draggingPasteboard.propertyList(forType: .backwardsCompatibleFileURL) as? NSArray,
            let path = board.firstObject as? String
        else {
            return false
        }
    
        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }
    
//    override func draggingExited(_ sender: NSDraggingInfo?) {
//        self.layer?.backgroundColor = NSColor.gray.cgColor
//    }
//
//    override func draggingEnded(_ sender: NSDraggingInfo) {
//        self.layer?.backgroundColor = NSColor.gray.cgColor
//    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard.propertyList(forType: .backwardsCompatibleFileURL) as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        //GET YOUR FILE PATH !!!
//        self.filePath = path
        print("FilePath: \(path)")
        
        return true
    }
}

extension NSPasteboard.PasteboardType {
    
    /// NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")
    /// https://stackoverflow.com/a/46514780/5893286
    static let backwardsCompatibleFileURL: NSPasteboard.PasteboardType = {
        //return NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")
        if #available(OSX 10.13, *) {
            return NSPasteboard.PasteboardType.fileURL
//            return NSPasteboard.PasteboardType.URL
        } else {
//            return NSPasteboard.PasteboardType(kUTTypeURL as String)
            return NSPasteboard.PasteboardType(kUTTypeFileURL as String)
        }
    }()
    
}

class DropView2: NSView {
    
    private var allowedExtensions = [String]()
    
    private var handler: ((_ paths: [String]) -> Void)?
    
    func setup(ext: [String], handler: @escaping (_ paths: [String]) -> Void) {
        self.allowedExtensions = ext
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
        //super.draw(dirtyRect)
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
//        if isAllowedExtension(in: sender) {
//            return .copy
//        } else {
//            //return []
//            return NSDragOperation()
//        }
    }
    
    fileprivate func isAllowedExtension(in sender: NSDraggingInfo) -> Bool {
        /// https://stackoverflow.com/a/51344295/5893286
        guard let dropUrls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self],options: nil) as? [URL] else {
            return false
        }
        let dropFileExtensions = dropUrls.map { $0.pathExtension }
        
        /// if one file is allowed, will allow drop
        for fileExtension in dropFileExtensions {
            if allowedExtensions.contains(where: { $0.caseInsensitiveCompare(fileExtension) == .orderedSame }) {
                return true
            }
        }
        return false
        
        /// if one file is not allowed, will not allow drop
        //for fileExtension in fileExtensions {
        //    if !allowedExtensions.contains(where: { $0.caseInsensitiveCompare(fileExtension) == .orderedSame }) {
        //        return false
        //    }
        //}
        //return true
        
        
        
//        guard let board = drag.draggingPasteboard.propertyList(forType: .backwardsCompatibleFileURL) as? NSArray,
//            let path = board.firstObject as? String
//            else {
//                return false
//        }
//        let suffix = URL(fileURLWithPath: path).pathExtension
        
//        for ext in self.expectedExt {
//            if ext.caseInsensitiveCompare(suffix) == .orderedSame {
//                return true
//            }
////            if ext.lowercased() == suffix.lowercased() {
////                return true
////            }
//        }
//        return false
    }
    
//    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
//        return true
//    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        
//        guard let pasteboard = sender.draggingPasteboard.propertyList(forType: .backwardsCompatibleFileURL) as? NSArray,
//            let path = pasteboard[0] as? String
//        else {
//            return false
//        }
        
        /// Convert the window-based coordinate to a view-relative coordinate
        /// start from left-bottom corner
        //let point = convert(sender.draggingLocation, from: nil)
        //print(point)
        
        guard let urls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self],options: nil) as? [URL] else {
            assertionFailure()
            return false
        }
        let paths = urls
            .filter { url in
                allowedExtensions.contains(where: {
                    $0.caseInsensitiveCompare(url.pathExtension) == .orderedSame
                })
            }.map { $0.path }
        handler?(paths)
        return true
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
}
