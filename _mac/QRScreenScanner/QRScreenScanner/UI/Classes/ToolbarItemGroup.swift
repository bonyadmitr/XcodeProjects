import Cocoa

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
