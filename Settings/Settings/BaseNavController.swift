//
//  BaseNavController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

//import UIKit
//
//class BaseController: UIViewController {
//
//    var statusBarStyle = AppearanceStyle.light
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return statusBarStyle.statusBar
//    }
//
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    private func setup() {
//        AppearanceConfigurator.shared.register(self)
//        // TODO: need to check for subclasses
//        restorationIdentifier = String(describing: type(of: self))
//        restorationClass = type(of: self)
//    }
//}
//extension BaseController: AppearanceConfiguratorDelegate {
//    func didApplied(theme: AppearanceTheme) {
//        statusBarStyle = theme.barStyle
//    }
//}

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

final class BaseNavController: UINavigationController {
    
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
        title = topViewController?.title
        
        tabBarItem = topViewController?.tabBarItem
        
        /// hide tab bar on push in view has a slight delay
        /// don't need for iOS 11. need for iOS 10 with hideButtomOnpush
//        edgesForExtendedLayout = []
        edgesForExtendedLayout = [.bottom]
        
        /// fixed tabbar appearance on push for child controllers
        /// not working for master vc in split controller for iPhone+ landscape mode
//        edgesForExtendedLayout = [.all]
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// to remove translucent navigation bar shadow on push and pop actions
//        view.backgroundColor = UIColor.white
    }
}
