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
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return durationn
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        let container = transitionContext.containerView
//        if destinationVC.modalPresentationStyle != .overFullScreen {
//            container.addSubview(toView)
//        }
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
        
        // perform the animation!
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            
            if self.isPresenting {
                fromView.transform = offScreenLeft
            } else {
                fromView.transform = offScreenRight
            }
            
            toView.transform = .identity
            
        }, completion: {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}
