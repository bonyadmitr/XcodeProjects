//
//  BaseNavController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class BaseSplitController: UISplitViewController {
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        preferredDisplayMode = .allVisible
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
        
        ///Hide tab bar in view with push has a slight delay
        edgesForExtendedLayout = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// to remove navigation bar shadow on back action
        view.backgroundColor = UIColor.white
    }
}
