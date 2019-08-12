import Cocoa

/// https://stackoverflow.com/a/34278766/5893286
/// https://stackoverflow.com/a/45518276/5893286
/// https://www.raywenderlich.com/1016-drag-and-drop-tutorial-for-macos
/// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/DragandDrop/Tasks/DraggingFiles.html
class DropView: NSView {
    
    /// "fileTypes" should be set before using "filteringOptions"
    private lazy var filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes: fileTypes]
    
    private var isSubview = true
    private var fileTypes = [String]()
    private var handler: ((_ paths: [String]) -> Void)?
    
    /// call before using Drag&Drop
    func setup(isSubview: Bool, fileTypes: [String], handler: @escaping (_ paths: [String]) -> Void) {
        self.isSubview = isSubview
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
    
    //we override hitTest so that this view which sits at the top of the view hierachy
    //appears transparent to mouse clicks
    override func hitTest(_ aPoint: NSPoint) -> NSView? {
        return isSubview ? nil : super.hitTest(aPoint)
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
        let isAllowed = isAllowedDraging(in: sender)
        isReceivingDrag = isAllowed
        return isAllowed ? .copy : NSDragOperation()
    }
    
    fileprivate func isAllowedDraging(in sender: NSDraggingInfo) -> Bool {
        return sender.draggingPasteboard.canReadObject(forClasses: [NSURL.self], options: filteringOptions)
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return isAllowedDraging(in: sender)
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let urls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: filteringOptions) as? [URL] else {
            assertionFailure()
            return false
        }
        assert(!urls.isEmpty, "one url must exists here. urls filtered by isAllowedDraging")
        let paths = urls.map { $0.path }
        handler?(paths)
        return true
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        isReceivingDrag = false
    }
}

class DropViewByExtensions: NSView {
    
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
    
    fileprivate func isAllowedExtension(in sender: NSDraggingInfo) -> Bool {
        /// readObjects https://stackoverflow.com/a/51344295/5893286
        guard let dropUrls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self],options: nil) as? [URL] else {
            return false
        }
        let dropFileExtensions = dropUrls.map { $0.pathExtension }
        
        /// or #1. if one file is allowed, will allow drop
        for fileExtension in dropFileExtensions {
            if allowedExtensions.contains(where: { $0.caseInsensitiveCompare(fileExtension) == .orderedSame }) {
                return true
            }
        }
        return false
        
        /// or #2. if one file is not allowed, will not allow drop
        //for fileExtension in fileExtensions {
        //    if !allowedExtensions.contains(where: { $0.caseInsensitiveCompare(fileExtension) == .orderedSame }) {
        //        return false
        //    }
        //}
        //return true
    }
    
    //    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
    //        return true
    //    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
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
