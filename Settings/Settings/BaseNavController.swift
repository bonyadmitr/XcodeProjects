//
//  BaseNavController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard traitCollection.forceTouchCapability == .available else {
//            /// Fall back to other non 3D Touch features
//            return
//        }
//
////        tabBar.items?.compactMap { item in
////            item.title
////        }
//
//        guard
//            let viewControllers = viewControllers,
//            viewControllers.count >= 2,
//            let vc1 = viewControllers[0] as? ViewController
//        else {
//            assertionFailure()
//            return
//        }
//
//
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

final class HideTabBarNavController: UINavigationController {
    
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
        edgesForExtendedLayout = []
        
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
