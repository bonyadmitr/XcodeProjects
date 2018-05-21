//
//  UIApplication+topController.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 11/17/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func topController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topController(controller: presented)
        }
        return controller
    }
}
