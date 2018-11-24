//
//  TabBarController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    /// possible fix of tab bar for iPhone X (reproducible sometimes)
    /// https://stackoverflow.com/a/47225568
    //    override func viewWillLayoutSubviews() {
    //        super.viewWillLayoutSubviews()
    //        tabBar.invalidateIntrinsicContentSize()
    //    }
    
    /// don't call super. it will crash. it is UITabBarDelegate method
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        VibrationManager.shared.lightVibrate()
        SoundManager.shared.playTapSound()
    }
}

// MARK: - UIKeyCommands
extension TabBarController {
    
    private enum KeyCommands: String {
        case first = "1"
        case settings = "2"
        
        var discoverabilityTitle: String {
            switch self {
            case .first:
                return L10n.language
            case .settings:
                return L10n.settings
            }
        }
    }
    
    /// input: "\u{8}" for backspace(delete) key
    /// https://stackoverflow.com/a/27608606
    /// can be created privateLazyKeyCommands bcz there are a lot of calls of "var keyCommands"
    override var keyCommands: [UIKeyCommand]? {
        return [KeyCommands.first, .settings].map { keyComand in
            UIKeyCommand(input: keyComand.rawValue,
                         modifierFlags: .command,
                         action: #selector(keyCommandPressed),
                         discoverabilityTitle: keyComand.discoverabilityTitle)
        }
    }
    
    @objc private func keyCommandPressed(_ sender: UIKeyCommand) {
        guard let keyinput = sender.input, let keyCommand = KeyCommands(rawValue: keyinput) else {
            assertionFailure()
            return
        }
        
        switch keyCommand {
        case .first:
            selectedIndex = 0
        case .settings:
            selectedIndex = 1
        }
    }
}
