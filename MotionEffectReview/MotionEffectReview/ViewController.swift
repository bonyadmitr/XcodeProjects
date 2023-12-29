//
//  ViewController.swift
//  MotionEffectReview
//
//  Created by Yaroslav Bondar on 22.12.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var buttonImageView: UIImageView!
    @IBOutlet private weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonView.layer.cornerRadius = 16
        buttonView.layer.cornerCurve = .continuous
        buttonView.layer.borderColor = UIColor.white.cgColor
        buttonView.layer.borderWidth = 1
        
        
        applyMotionEffect(to: buttonImageView, magnitude: 40)
        //applyMotionEffect(to: backgroundImageView, magnitude: 40)
    }
    
    // TODO: check disable on reduce motion accability
    /*
     Could you check a few things that might be a source of the problem:
     
     Double check that Settings > Accessibility > Motion > Reduce Motion is not turned on. Because if it is turned on, then UIInterpolatingMotionEffect won't work.
     Test that the accelerometer of the device that you are testing on actually works. Or better still, use another device to test it. (This won't work on the simulator).
     If you are editing the frame of the imageView in code anywhere (or especially in viewWillLayout / viewDidLayout), you shouldn't be doing that.
     https://stackoverflow.com/a/61948741/5893286

     */
    //parallax effect extension https://gist.github.com/NSHouseCat/3d1f4691b6e56903097a01f1ba898e54 or https://gist.github.com/rtking1993/e0692e99f0dde15b3cbb32eee0ef8ca0
    func applyMotionEffect(to view: UIView, magnitude: Float) {
        
        //#keyPath(UIView.center.x)
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }


}

