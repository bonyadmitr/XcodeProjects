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
extension BaseSplitController: AppearanceConfiguratorDelegate {
    func didApplied(theme: AppearanceTheme) {
        statusBarStyle = theme.barStyle
    }
    
    
}
extension BaseSplitController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
