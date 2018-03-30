//
//  AnimationFlowManager.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 28/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://stackoverflow.com/questions/2306870/is-there-a-way-to-pause-a-cabasicanimation/40400230#40400230
protocol AnimationFlowManager {
    func pauseAnimations()
    func resumeAnimations()
}
extension AnimationFlowManager where Self: UIView {
    func pauseAnimations() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeAnimations() {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}
