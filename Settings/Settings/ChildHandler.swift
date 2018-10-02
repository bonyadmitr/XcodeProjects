//
//  ChildHandler.swift
//  Settings
//
//  Created by Bondar Yaroslav on 01/10/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// ParantController/ChildHandler/ChildManager
protocol ChildHandler {
    func add(childController: UIViewController, to container: UIView?)
}

extension ChildHandler where Self:UIViewController {
    
    func add(childController: UIViewController, to container: UIView? = nil) {
        guard let holderView = container ?? view else {
            assertionFailure()
            return
        }
        
        addChildViewController(childController)
        childController.view.frame = holderView.bounds
        childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        holderView.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }
}

extension UIViewController {
    func removeFromParentVC() {
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
