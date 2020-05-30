//
//  ViewController.swift
//  NavigationBasic
//
//  Created by Bondar Yaroslav on 5/29/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension UINavigationController {
    
    /// source https://stackoverflow.com/a/25230169/5893286
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool,
                            completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func replaceTopViewController(_ viewController: UIViewController, animated: Bool) {
        var currentStack = viewControllers
        if currentStack.isEmpty {
            pushViewController(viewController, animated: animated)
        } else {
            currentStack[currentStack.count - 1] = viewController
            setViewControllers(currentStack, animated: animated)
        }
    }
    
}
