//
//  UISearchController+Layout.swift
//  tvOStest
//
//  Created by Bondar Yaroslav on 8/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

@available(tvOS 9.0, *)
extension UISearchController {
    /// call it once in viewDidAppear
    /// it using private api that was passed to the app store
    func moveSearchBarToCenter() {
        for constraint in view.constraints {
            if let className = constraint.firstItem?.classForCoder, className.description() == "UIKBFocusVCView" {
                constraint.constant = 500
            }
        }
        
        let newFrame = CGRect(x: searchBar.frame.minX, y: searchBar.frame.minY + 317, width: 600, height: 79)
        searchBar.frame = newFrame
    }
}
