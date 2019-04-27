//
//  ViewController.swift
//  LaunchAtLoginDepricated
//
//  Created by Bondar Yaroslav on 4/26/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


import Foundation

/// new tutorials
/// https://stackoverflow.com/questions/35339277/make-swift-cocoa-app-launch-on-startup-on-os-x-10-11
///
/// https://github.com/sindresorhus/LaunchAtLogin
/// https://github.com/sindresorhus/LaunchAtLogin/blob/master/LaunchAtLogin/LaunchAtLogin.swift
/// https://github.com/sindresorhus/LaunchAtLogin/blob/master/LaunchAtLoginHelper/main.swift
///
/// https://github.com/KrauseFx/overkill-for-mac/blob/master/Overkill/LaunchStarter.swift
/// https://github.com/ptsochantaris/trailer/blob/master/Trailer/StartupLaunch.swift
///
/// https://snippets.aktagon.com/snippets/362-how-to-set-an-application-to-load-at-login-with-cocoa-and-objective-c
final class StartupLauncher {
    
    static let shared = StartupLauncher()
    
    private let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
    
    private let loginItemRef: LSSharedFileList = {
        return LSSharedFileListCreate(nil,
                                      kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                                      nil).takeRetainedValue() as LSSharedFileList
    }()
    
    private func loginItems() -> [LSSharedFileListItem]? {
        return LSSharedFileListCopySnapshot(loginItemRef,
                                            nil).takeRetainedValue() as? [LSSharedFileListItem]
    }
    
    private func appItem(from loginItems: [LSSharedFileListItem]) -> LSSharedFileListItem? {
        return loginItems.first(where: { item in
            let itemUrl = LSSharedFileListItemCopyResolvedURL(item, 0, nil).takeRetainedValue() as URL
            return itemUrl == appUrl
        })
    }
    
    func setLogin(login: Bool) {
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
    
    func isAppLoginItem() -> Bool {
        guard let loginItems = loginItems() else {
            assertionFailure()
            return false
        }
        return appItem(from: loginItems) != nil
    }
    
    func toggle() {
        setLogin(login: !isAppLoginItem())
    }
    
    var isLaunchAtLogin: Bool {
        get {
            return isAppLoginItem()
        }
        set {
            setLogin(login: newValue)
        }
    }
}
