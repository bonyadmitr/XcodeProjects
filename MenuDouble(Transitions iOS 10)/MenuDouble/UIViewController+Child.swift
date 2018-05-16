//
//  UIViewController + Child.swift
//  MenuDrawer
//
//  Created by Yaroslav Bondar on 20.07.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func add(child: UIViewController, to container: UIView) {
        addChildViewController(child)
        container.addSubview(child.view)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.constrainEdges(toMarginOf: container)
        child.didMove(toParentViewController: self)
    }

    func add(child: UIViewController) {
        add(child: child, to: self.view)
    }

    func addChildWithNavItem(child: UIViewController, toContainer container: UIView) {
        add(child: child, to: container)
        // TODO: Settings for this !
        navigationItem.rightBarButtonItems = child.navigationItem.rightBarButtonItems
        navigationItem.leftBarButtonItems = child.navigationItem.leftBarButtonItems
        title = child.title
    }

    func addChildVCWithNavItem(child: UIViewController) {
        addChildWithNavItem(child: child, toContainer: self.view)
    }
    
    func removeFromContainer() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}

