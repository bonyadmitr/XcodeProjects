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
        child.view.layoutIfNeeded()
        child.didMove(toParentViewController: self)
    }
    
    func add(child: UIViewController) {
        add(child: child, to: self.view)
    }
    
    func removeFromContainer() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
