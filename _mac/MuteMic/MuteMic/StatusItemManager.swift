import Cocoa

final class StatusItemManager {
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private let statusItemMenu: NSMenu = {
        let menu = NSMenu()
        menu.addItem(withTitle: "qqq", action: nil, keyEquivalent: ",")
        return menu
    }()
    
    /// without storyboard can be create by lazy var + `_ = statusItem`.
    /// otherwise will be errors "0 is not a valid connection ID".
    /// https://habr.com/ru/post/447754/
    func setup() {
        statusItem.button.assertExecute { button in
            button.action = #selector(clickStatusItem)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    private let micOnImage = NSImage(named: NSImage.Name("mic_on"))
    private let micOffImage = NSImage(named: NSImage.Name("mic_off"))
    
    func setImage(for isMuted: Bool) {
        let image = isMuted ? micOffImage : micOnImage
        statusItem.button.assertExecute { $0.image = image }
    }
    
    @objc private func clickStatusItem() {
        guard let event = NSApp.currentEvent else {
            assertionFailure()
            return
        }
        
        /// .command is not called on NSStatusItem
        if event.modifierFlags.contains([.option])
            || event.modifierFlags.contains([.control])
            || event.type == .rightMouseUp
        {
            statusItem.popUpMenu(statusItemMenu)
        } else {
            AudioManager.shared.toogleMute()
        }
    }
    
}
