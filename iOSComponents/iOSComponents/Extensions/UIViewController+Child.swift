//
//  UIViewController+Child.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 31.01.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func add(childController: UIViewController, to container: UIView? = nil) {
        
        var holderView = self.view!
        if let container = container {
            holderView = container
        }
        
        addChildViewController(childController)
        childController.view.frame = holderView.bounds
        childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        holderView.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }
    
    func removeFromParentVC() {
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
