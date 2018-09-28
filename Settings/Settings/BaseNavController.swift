//
//  BaseNavController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

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
    }
}
