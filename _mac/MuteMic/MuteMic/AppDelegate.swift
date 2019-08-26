import Cocoa

/// Created on 8/17/19
final class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// NSStatusBar.system should be called after applicationDidFinishLaunching. use lazy init.
    lazy var statusItemManager = StatusItemManager()
    
    let audioManager = MuteMicManager.shared

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItemManager.setup()
        
        statusItemManager.setImage(for: audioManager.isMuted())
        audioManager.didChange = { [weak self] isMuted in
            DispatchQueue.main.async {
                self?.statusItemManager.setImage(for: isMuted)
            }
        }
    }
    
}
