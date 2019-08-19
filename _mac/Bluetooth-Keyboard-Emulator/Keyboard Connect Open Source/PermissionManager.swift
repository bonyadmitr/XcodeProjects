import Foundation

/// AXObserverAddNotification
/// https://stackoverflow.com/questions/853833/how-can-my-app-detect-a-change-to-another-apps-window
///
final class PermissionManager {
    //    static let shared = PermissionManager()
    
    /// "System Preferences - Security & Privacy - Privacy - Accessibility".
    func isAccessibilityAvailable() -> Bool {
        /// will not open system alert
        //return AXIsProcessTrusted()
        
        /// open system alert to the settings
        /// https://stackoverflow.com/a/36260107
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
    
    func isAccessibilityAvailableWithoutAlert() -> Bool {
        /// will not open system alert
        /// or #1
        return AXIsProcessTrusted()
        
        /// or #2
        //let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): false] as CFDictionary
        //return AXIsProcessTrustedWithOptions(options)
    }
}
