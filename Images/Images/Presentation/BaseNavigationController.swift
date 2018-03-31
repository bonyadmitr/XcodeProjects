//
//  BaseNavigationController.swift
//  Images
//
//  Created by Bondar Yaroslav on 10/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeNavigationBarShadowOnBack()
        removeHidingTabBarDelayOnPush()
    }
}
