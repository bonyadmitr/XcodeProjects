import Foundation

/// https://github.com/sindresorhus/LaunchAtLogin
/// https://github.com/sindresorhus/LaunchAtLogin/blob/master/LaunchAtLogin/LaunchAtLogin.swift
/// https://github.com/sindresorhus/LaunchAtLogin/blob/master/LaunchAtLoginHelper/main.swift
///
/// https://github.com/KrauseFx/overkill-for-mac/blob/master/Overkill/LaunchStarter.swift
/// https://github.com/ptsochantaris/trailer/blob/master/Trailer/StartupLaunch.swift
///
/// https://snippets.aktagon.com/snippets/362-how-to-set-an-application-to-load-at-login-with-cocoa-and-objective-c
enum LaunchAtLogin {
    
    static var isEnabled: Bool {
        get {
            return isAppLoginItem()
        }
        set {
            setAppAsLoginItem(newValue)
        }
    }
    
    static func toggle() {
        setAppAsLoginItem(!isAppLoginItem())
    }
    
    private static let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
    
    private static let loginItemRef: LSSharedFileList = {
        return LSSharedFileListCreate(nil,
                                      kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                                      nil).takeRetainedValue() as LSSharedFileList
    }()
    
    private static func loginItems() -> [LSSharedFileListItem]? {
        return LSSharedFileListCopySnapshot(loginItemRef,
                                            nil).takeRetainedValue() as? [LSSharedFileListItem]
    }
    
    private static func appItem(from loginItems: [LSSharedFileListItem]) -> LSSharedFileListItem? {
        return loginItems.first(where: { item in
            let itemUrl = LSSharedFileListItemCopyResolvedURL(item, 0, nil).takeRetainedValue() as URL
            return itemUrl == appUrl
        })
    }
    
    static func setAppAsLoginItem(_ login: Bool) {
        guard let loginItems = loginItems() else {
            assertionFailure()
            return
        }
        
        if login {
            LSSharedFileListInsertItemURL(loginItemRef, loginItems.last, nil, nil, appUrl as CFURL, nil, nil)
        } else {
            guard let appItem = appItem(from: loginItems) else {
                assertionFailure("don't turn off LaunchAtLogin if it is already off")
                return
            }
            LSSharedFileListItemRemove(loginItemRef, appItem)
        }
    }
    
    private static func isAppLoginItem() -> Bool {
        guard let loginItems = loginItems() else {
            assertionFailure()
            return false
        }
        return appItem(from: loginItems) != nil
    }
}
