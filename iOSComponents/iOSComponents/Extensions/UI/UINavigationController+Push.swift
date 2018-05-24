//
//  UINavigationController+Push.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 5/7/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /// https://stackoverflow.com/a/33767837/5893286
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping VoidHandler) {
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
    func pushViewControllerAndRemoveCurrentOnCompletion(_ viewController: UIViewController) {
        let currentIndex = viewControllers.count - 1
        guard viewControllers.count >= currentIndex else {
            return
        }
        pushViewController(viewController, animated: true) { [weak self] in
            self?.viewControllers.remove(at: currentIndex)
        }
    }
}
