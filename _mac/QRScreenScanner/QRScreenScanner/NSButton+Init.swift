import Cocoa

extension NSButton {
    convenience init(image: NSImage?, target: AnyObject?, action: Selector?) {
        self.init()
        self.image = image
        self.target = target
        self.action = action
        //        if #available(OSX 10.12, *) {
        //            self.init(image: image ?? NSImage(), target: target as Any, action: action)
        //        } else {
        //            self.init()
        //            self.image = image
        //            self.target = target
        //            self.action = action
        //        }
    }
}
