import Cocoa

final class StatusItemManager {
    
    //static let shared = StatusItemManager()
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    /// without storyboard can be create by lazy var + `_ = statusItem`.
    /// otherwise will be errors "0 is not a valid connection ID".
    /// https://habr.com/ru/post/447754/
    func setup() {
        guard let button = statusItem.button else {
            assertionFailure("system error. try statusItem.title")
            return
        }
        //button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        button.title = "QR"
        button.action = #selector(clickStatusItem)
        button.target = self
    }
    
    @objc private func clickStatusItem() {
        QRService.scanWindows()
    }

}
