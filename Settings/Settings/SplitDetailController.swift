//
//  SplitDetailController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 28/09/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class SplitDetailController: UIViewController {
    
    var childVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let childVC = childVC else {
            assertionFailure()
            return
        }
        
        add(childController: childVC)
    }
}

// TODO: ParantController/ChildHandler/ChildManager
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
