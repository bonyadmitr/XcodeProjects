//
//  TransitioningDelegate.swift
//  InteractionTransition
//
//  Created by Bondar Yaroslav on 15/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject {
    
    var animator: Animator!
    
    private override init() {
        super.init()
    }
    
    convenience init(animator: Animator) {
        self.init()
        self.animator = animator
    }
}
extension TransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
//        animator.isPresenting = false
//        return animator
    }
}
