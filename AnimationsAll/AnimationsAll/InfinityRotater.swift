//
//  InfinityRotater.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 28/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

private let infinityRotate360DegreesKey = "InfinityRotate360Degrees"

/// https://stackoverflow.com/questions/27755504/rotate-a-view-for-360-degrees-indefinitely-in-swift
protocol InfinityRotater {
    func startInfinityRotate360Degrees(duration: CFTimeInterval)
    func stopInfinityRotate360Degrees()
}
extension InfinityRotater where Self: UIView {
    
    func startInfinityRotate360Degrees(duration: CFTimeInterval) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
        layer.add(rotateAnimation, forKey: infinityRotate360DegreesKey)
    }
    
    func stopInfinityRotate360Degrees() {
        layer.removeAnimation(forKey: infinityRotate360DegreesKey)
    }
}
