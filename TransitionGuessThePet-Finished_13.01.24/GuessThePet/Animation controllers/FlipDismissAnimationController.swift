//
//  FlipDismissAnimationController.swift
//  GuessThePet
//
//  Created by Vesza Jozsef on 08/07/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var destinationFrame = CGRect.zero
    var animator: UIViewImplicitlyAnimating?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let anim = self.interruptibleAnimator(using: transitionContext)
        anim.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        if let animator = self.animator {
            return animator
        }
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let finalFrame = destinationFrame
        
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
        
        snapshot?.layer.cornerRadius = 25
        snapshot?.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)
        fromVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        
        toVC.view.layer.transform = AnimationHelper.yRotation(-.pi/2)
        
        let duration = transitionDuration(using: transitionContext)
        
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            UIView.animateKeyframes(
                withDuration: duration,
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                        snapshot?.frame = finalFrame
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                        snapshot?.layer.transform = AnimationHelper.yRotation(.pi/2)
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                        toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                    })
            }, completion: nil)
        }
        animator.addCompletion { finish in
            fromVC.view.isHidden = false
            snapshot?.removeFromSuperview()
            if finish == .end {
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
