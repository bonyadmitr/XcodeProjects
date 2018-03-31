//
//  UINavigationController+Bugs.swift
//  Images
//
//  Created by Bondar Yaroslav on 13/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// usage
/**
class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
 
        removeNavigationBarShadowOnBack()
        removeHidingTabBarDelayOnPush()
    }
}
*/
extension UINavigationController {
    /// to remove navigation bar shadow on back action
    /// https://stackoverflow.com/questions/22413193/dark-shadow-on-navigation-bar-during-segue-transition-after-upgrading-to-xcode-5
    func removeNavigationBarShadowOnBack() {
        view.backgroundColor = UIColor.white
    }
    //    @IBInspectable var removeNavigationBarShadowOnBack: Bool {
    //        get {
    //            return view.backgroundColor == UIColor.white
    //        }
    //        set {
    //            if newValue {
    //                view.backgroundColor = UIColor.white
    //            }
    //        }
    //    }
    
    ///Hide tab bar in view with push has a slight delay
    ///Select your "Navigation Controller" and in "Attribute Inspector" remove the checkmark from "Under Bottom Bars".
    func removeHidingTabBarDelayOnPush() {
        edgesForExtendedLayout = []
    }
    //    @IBInspectable var removeHidingTabBarDelayOnPush: Bool {
    //        get {
    //            return edgesForExtendedLayout == []
    //        }
    //        set {
    //            if newValue {
    //                edgesForExtendedLayout = []
    //            }
    //        }
    //    }
}
