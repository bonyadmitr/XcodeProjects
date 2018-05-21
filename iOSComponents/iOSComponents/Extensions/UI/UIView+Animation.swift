//
//  UIView+Animation.swift
//  SwiftBest
//
//  Created by zdaecqze zdaecq on 24.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

private let UIViewAnimationDuration: NSTimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5


extension UIView {
    
    /// EZSwiftExtensions
    public func spring(animations animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }
    
    /// EZSwiftExtensions
    public func spring(duration duration: NSTimeInterval, animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animateWithDuration(
            UIViewAnimationDuration,
            delay: 0,
            usingSpringWithDamping: UIViewAnimationSpringDamping,
            initialSpringVelocity: UIViewAnimationSpringVelocity,
            options: UIViewAnimationOptions.AllowAnimatedContent,
            animations: animations,
            completion: completion
        )
    }
    
    /// EZSwiftExtensions
    public func animate(duration duration: NSTimeInterval, animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animateWithDuration(duration, animations: animations, completion: completion)
    }
    
    /// EZSwiftExtensions
    public func animate(animations animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        animate(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }
    
    /// EZSwiftExtensions
    public func pop() {
        setScale(x: 1.1, y: 1.1)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
            })
    }
    
    /// EZSwiftExtensions
    public func popBig() {
        setScale(x: 1.25, y: 1.25)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
            })
    }
    
    ///EZSE: Shakes the view for as many number of times as given in the argument.
    public func shakeViewForTimes(times: Int) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(CATransform3D: CATransform3DMakeTranslation(-5, 0, 0 )),
            NSValue(CATransform3D: CATransform3DMakeTranslation( 5, 0, 0 ))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7/100
        
        self.layer.addAnimation(anim, forKey: nil)
    }
}