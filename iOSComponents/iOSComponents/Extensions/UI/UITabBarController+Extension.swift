//
//   UITabBarController+Extension.swift
//  Tasty
//
//  Created by Vitaliy Kuzmenko on 15/10/14.
//  Copyright (c) 2014 Vitaliy Kuz'menko. All rights reserved.
//

import UIKit

// TODO: !!! need to test !!!
// MARK: maybe will be enough UIViewController+TabBar
extension UITabBarController {

    func setTabBarHidden(hidden: Bool, animated: Bool) {

        let tabBarHeight: CGFloat = 49

        if view.subviews.count < 2 {
            return
        }

        var contentView: UIView!

        if view.subviews.first?.isKindOfClass(UITabBar) == true {
            contentView = view.subviews[1]
        } else {
            contentView = view.subviews.first
        }

        if hidden {

            let frame = CGRectMake(view.bounds.origin.x, view.bounds.size.height, view.bounds.size.width, tabBarHeight)

            if animated {

                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    contentView.frame = self.view.bounds
                    self.tabBar.frame = frame
                }, completion: { (flag) -> Void in
//                    self.tabBar.hidden = true
                })

            } else {
                contentView.frame = self.view.bounds
                self.tabBar.frame = frame
//                self.tabBar.hidden = true
            }
        } else {
            self.tabBar.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height, self.view.bounds.size.width, 0)

            let tabBarframe = CGRectMake(view.bounds.origin.x, view.bounds.size.height - tabBarHeight, view.bounds.size.width, tabBarHeight)
            let contentViewFrame = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height - tabBarHeight)

            if animated {
//                self.tabBar.hidden = false
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.tabBar.frame = tabBarframe
                }, completion: { (flag) -> Void in
                    contentView.frame = contentViewFrame
                })
            } else {
                tabBar.frame = tabBarframe
                contentView.frame = contentViewFrame
//                self.tabBar.hidden = false
            }
        }

    }

}
