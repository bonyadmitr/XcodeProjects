//
//  UIViewController+Extensions.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIViewController {
    var rootIfNavOrSelf: UIViewController {
        if let navVC = self as? UINavigationController {
            return navVC.visibleViewController ?? navVC
        } else {
            return self
        }
    }
}
