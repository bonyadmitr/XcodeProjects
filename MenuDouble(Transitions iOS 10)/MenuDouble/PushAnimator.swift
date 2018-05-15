//
//  PushAnimator.swift
//  InteractionTransition
//
//  Created by Bondar Yaroslav on 14/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class AnimationController: NSObject {
    var durationn: TimeInterval = 0.3
    var isPresenting: Bool = true
    var animator: UIViewImplicitlyAnimating?
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return durationn
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let anim = self.interruptibleAnimator(using: transitionContext)
        anim.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let animator = self.animator {
            return animator
        }
        
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        let container = transitionContext.containerView
        container.addSubview(toView)
        //        container.addSubview(fromView)
        
        
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        if isPresenting {
            toView.transform = offScreenRight
        } else {
            toView.transform = offScreenLeft
        }
        
        
        let duration = transitionDuration(using: transitionContext)
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            if self.isPresenting {
                fromView.transform = offScreenLeft
            } else {
                fromView.transform = offScreenRight
            }
            
            toView.transform = .identity
        }
        animator.addCompletion { finish in
            if finish == .end {
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//                transitionContext.finishInteractiveTransition()
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
            } else {
                transitionContext.cancelInteractiveTransition()
                transitionContext.completeTransition(false)
            }
        }
        
        self.animator = animator
        return animator
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        self.animator = nil
    }
}
