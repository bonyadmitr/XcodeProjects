import Cocoa

extension NSToolbarItem {
    convenience init(itemIdentifier: NSToolbarItem.Identifier,
                     label: String,
                     image: NSImage?,
                     target: AnyObject?,
                     action: Selector)
    {
        let button = NSButton(image: image, target: target, action: action)
        button.title = ""
        button.imageScaling = .scaleProportionallyDown
        button.bezelStyle = .texturedRounded
        button.focusRingType = .none
        
        self.init(itemIdentifier: itemIdentifier)
        self.label = label
        self.paletteLabel = label
        self.view = button
    }
}
