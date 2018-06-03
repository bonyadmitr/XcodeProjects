//
//  AnimationFlowManager.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 3/29/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import UIKit

/// https://stackoverflow.com/questions/2306870/is-there-a-way-to-pause-a-cabasicanimation/40400230#40400230
/// https://stackoverflow.com/a/43934404/5893286
protocol AnimationFlowManager: class {
    var persistentAnimations: [String: CAAnimation] { get set }
    var persistentSpeed: Float { get set }
    func pauseAnimations()
    func resumeAnimations()
}
extension AnimationFlowManager where Self: UIView {
    func pauseAnimations() {
        persistentSpeed = layer.speed
        layer.speed = 1.0 //in case layer was paused from outside, set speed to 1.0 to get all animations
        persistAnimations(withKeys: layer.animationKeys())
        layer.speed = persistentSpeed //restore original speed
        
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeAnimations() {
        restoreAnimations(withKeys: Array(persistentAnimations.keys))
        persistentAnimations.removeAll()
        
        if persistentSpeed == 0 {
            return
        }
        
        ///if layer was plaiyng before backgorund, resume it
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    private func persistAnimations(withKeys: [String]?) {
        withKeys?.forEach({ (key) in
            if let animation = layer.animation(forKey: key) {
                persistentAnimations[key] = animation
            }
        })
    }
    
    private func restoreAnimations(withKeys: [String]?) {
        withKeys?.forEach { key in
            if let persistentAnimation = persistentAnimations[key] {
                layer.add(persistentAnimation, forKey: key)
            }
        }
    }
}

