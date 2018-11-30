//
//  ShortcutManager.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum Shortcut: String {
    case language
    case settings
}

final class ShortcutManager {
    
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func handle(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let shortcutItem = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
            //shortcutItemToProcess = shortcutItem
            _ = handleQuickAction(shortcutItem)
        }
    }
    
    func registerShortcutItemsIfNeed() {
        /// we don't need register twice or 3D touch is not available or disabled
        guard
            UIApplication.shared.shortcutItems?.isEmpty == true,
            UIScreen.main.traitCollection.forceTouchCapability == .available
        else {
            /// Fall back to other non 3D Touch features
            return
        }
        
        let newShortcutItem1 = UIApplicationShortcutItem(type: Shortcut.language.rawValue,
                                                         localizedTitle: L10n.language,
                                                         localizedSubtitle: nil,
                                                         icon: UIApplicationShortcutIcon(type: .compose),
                                                         userInfo: nil)
        
        let newShortcutItem2 = UIApplicationShortcutItem(type: Shortcut.settings.rawValue,
                                                         localizedTitle: L10n.settings,
                                                         localizedSubtitle: nil,
                                                         icon: UIApplicationShortcutIcon(templateImageName: "ic_settings"),
                                                         userInfo: nil)
        
        UIApplication.shared.shortcutItems = [newShortcutItem1, newShortcutItem2]
    }
    
    func handleQuickAction(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        guard
            let shortcutType = Shortcut(rawValue: shortcutItem.type),
            let tabBarVC = window?.rootViewController as? UITabBarController
        else {
            assertionFailure()
            return false
        }
        
        switch shortcutType {
        case .language:
            tabBarVC.selectedIndex = 0
        case .settings:
            tabBarVC.selectedIndex = 1
        }
        
        return true
    }
}
