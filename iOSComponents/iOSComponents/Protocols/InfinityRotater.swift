//
//  UIView+Rorate.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 3/27/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import UIKit

private let infinityRotate360DegreesKey = "InfinityRotate360Degrees"

protocol InfinityRotater {
    func startInfinityRotate360Degrees(duration: CFTimeInterval)
    func stopInfinityRotate360Degrees()
}
extension InfinityRotater where Self: UIView {
    
    func startInfinityRotate360Degrees(duration: CFTimeInterval) {
        guard layer.animation(forKey: infinityRotate360DegreesKey) == nil else {
            print("⚠️ startInfinityRotate360Degrees called before stop ⚠️")
            return
        }
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = Double.pi * 2.0
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = .infinity
        layer.add(rotateAnimation, forKey: infinityRotate360DegreesKey)
    }
    
    func stopInfinityRotate360Degrees() {
        layer.removeAnimation(forKey: infinityRotate360DegreesKey)
    }
}

final class RotatingImageView: UIImageView, InfinityRotater, AnimationFlowManager {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var persistentAnimations: [String: CAAnimation] = [:]
    var persistentSpeed: Float = 0.0
    
    @objc private func didBecomeActive() {
        resumeAnimations()
    }
    
    @objc private func willResignActive() {
        pauseAnimations()
    }
}
