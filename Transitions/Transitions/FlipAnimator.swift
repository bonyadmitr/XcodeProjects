//
//  FlipAnimator.swift
//  Transitions
//
//  Created by Bondar Yaroslav on 24/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://github.com/ColinEberhardt/VCTransitionsLibrary/blob/master/AnimationControllers/CEFlipAnimationController.m
/// https://github.com/ColinEberhardt/VCTransitionsLibrary/blob/4ce0512ffac852abf44643295860661366230d9f/AnimationControllers/CEPortalAnimationController.m

class FlipAnimator: NSObject, Animator {
    var duration: TimeInterval = 2
    var isPresenting = true
}

extension FlipAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = transitionDuration(using: transitionContext)
        
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        let container = transitionContext.containerView
        container.addSubview(toView)
        
        
        /// start state
        let snaps = createSnapshots(from: toView)
        
        
        
        
        let backView = UIView(frame: snaps.1.frame)
        backView.backgroundColor = UIColor.purple
        toView.superview!.addSubview(backView)
        
        backView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        backView.frame = backView.frame.offsetBy(dx: -0.5 * backView.frame.width, dy: 0)
        
//        updateAnchorPointAndOffset(CGPoint(x: 0, y: 0.5), view: snaps.0)
//        updateAnchorPointAndOffset(CGPoint(x: 1, y: 0.5), view: snaps.1)
        
        snaps.0.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        snaps.0.frame = snaps.0.frame.offsetBy(dx: 0.5 * snaps.0.frame.width, dy: 0)
        
//        snaps.0.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
//        snaps.1.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        
        
        snaps.0.alpha = 0
        snaps.0.layer.transform = rotate(.pi/1.0001)
        // CATransform3DScale(rotate(.pi/1.0001), 0.001, 0.001, 0.001)
        
//        snaps.0.transform = snaps.0.transform.scaledBy(x: 0.001, y: 0.001)
        snaps.1.alpha = 0
//        snaps.1.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        
        
        backView.layer.transform = CATransform3DScale(rotate(.pi/1.0001), 0.001, 0.001, 0.001)
        
        //        container.addSubview(fromView)
        
        
//        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
//        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
//        
//        if isPresenting {
//            toView.transform = offScreenRight
//        } else {
//            toView.transform = offScreenLeft
//        }
        
        
        
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: { 
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
//                snaps.0.transform.scaledBy(x: 1000, y: 1000)
                backView.layer.transform = self.rotate(.pi/1.0001)
//                snaps.1.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0) {
                snaps.0.alpha = 1
                snaps.1.alpha = 1
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0) {
                backView.alpha = 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1) {
//                snaps.0.layer.transform = self.rotate(0.0001)
                snaps.0.layer.transform = CATransform3DIdentity
                backView.layer.transform = CATransform3DIdentity
//                snaps.1.transform = .identity
            }
            
        }, completion: {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            self.removeOtherViews(fromView)
            self.removeOtherViews(toView)
        })
        
        
        
        
        
        // perform the animation!
//        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
//            
//            if self.isPresenting {
//                fromView.transform = offScreenLeft
//            } else {
//                fromView.transform = offScreenRight
//            }
//            
//            toView.transform = .identity
//            
//        }, completion: {_ in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        })
        
    }
    
    func removeOtherViews(_ viewToKeep: UIView) {
        let containerView = viewToKeep.superview!
        for view in containerView.subviews {
            if view != viewToKeep {
                view.removeFromSuperview()
            }
        }
    }

    
    
    func createSnapshots(from view: UIView) -> (UIView, UIView) {
        
        let containerView = view.superview!
        let halfWidth = view.frame.width / 2
        
        // snapshot the left-hand side of the view
        var snapshotRegion = CGRect(x: 0, y: 0, width: halfWidth, height: view.frame.height)
        let leftHandView = view.resizableSnapshotView(from: snapshotRegion,
                                                      afterScreenUpdates: true,
                                                      withCapInsets: .zero)!
        leftHandView.frame = snapshotRegion
        containerView.addSubview(leftHandView)
        
        // snapshot the right-hand side of the view
        
        snapshotRegion = CGRect(x: halfWidth, y: 0, width: halfWidth, height: view.frame.height)
        let rightHandView = view.resizableSnapshotView(from: snapshotRegion,
                                                       afterScreenUpdates: true,
                                                       withCapInsets: .zero)!
        rightHandView.frame = snapshotRegion
        containerView.addSubview(rightHandView)
        
        // send the view that was snapshotted to the back
        containerView.sendSubview(toBack: view)
        return (leftHandView, rightHandView)
    }
    
    func updateAnchorPointAndOffset(_ anchorPoint: CGPoint, view: UIView) {
        view.layer.anchorPoint = anchorPoint
        let xOffset = anchorPoint.x - 0.5
        view.frame = view.frame.offsetBy(dx: xOffset * view.frame.width, dy: 0)
    }
    
    func rotate(_ angle: CGFloat) -> CATransform3D {
        return CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0)
    }
}
