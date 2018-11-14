//
//  BaseSplitController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/3/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class BaseSplitController: UISplitViewController {
    
    private var statusBarStyle = AppearanceStyle.light
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle.statusBar
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        /// will be called on UITabBarController loading, UITabBarItem title will be set with this title
        title = viewControllers.first?.title
        
        tabBarItem = viewControllers.first?.tabBarItem
        delegate = self
        //        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
        statusBarStyle = AppearanceConfigurator.shared.currentTheme.barStyle
        AppearanceConfigurator.shared.register(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// don't call in setup func (will crash)
        /// need for iPad in portrait mode
        preferredDisplayMode = .allVisible
    }
}

// MARK: - AppearanceConfiguratorDelegate
extension BaseSplitController: AppearanceConfiguratorDelegate {
    func didApplied(theme: AppearanceTheme) {
        statusBarStyle = theme.barStyle
    }
}

// MARK: - UISplitViewControllerDelegate
extension BaseSplitController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewController.DisplayMode {
        switch svc.displayMode {
        case .primaryHidden:
            return .allVisible
        case .allVisible, .primaryOverlay, .automatic:
            return .primaryHidden
        }
    }
}

// MARK: - UIKeyCommands
extension BaseSplitController {
    
    private enum KeyCommands: String {
        case fullscreen = "f"
        
        var discoverabilityTitle: String {
            switch self {
            case .fullscreen:
                return L10n.fullScreen
            }
        }
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [KeyCommands.fullscreen].map { keyComand in
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
        case .fullscreen:
            toggleDisplayMode()
        }
    }
}

