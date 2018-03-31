//
//  FlipPresentAnimationController.swift
//  GuessThePet
//
//  Created by Vesza Jozsef on 08/07/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  var originFrame = CGRect.zero
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
    let containerView = transitionContext.containerView
    let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    
    let initialFrame = originFrame
    let finalFrame = transitionContext.finalFrame(for: toVC)
    
    let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
    
    snapshot?.frame = initialFrame
    snapshot?.layer.cornerRadius = 25
    snapshot?.layer.masksToBounds = true
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapshot!)
    toVC.view.isHidden = true
    
    AnimationHelper.perspectiveTransformForContainerView(containerView)
    
    snapshot?.layer.transform = AnimationHelper.yRotation(.pi/2)
    
    let duration = transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: .calculationModeCubic,
      animations: {
        
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
          fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi/2)
        })
        
        UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
          snapshot?.layer.transform = AnimationHelper.yRotation(0.0)
        })
        
        UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
          snapshot?.frame = finalFrame
        })
      },
      completion: { _ in
        toVC.view.isHidden = false
        snapshot?.removeFromSuperview()
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
  }
}
