//
//  ViewController.swift
//  3DTouch
//
//  Created by Bondar Yaroslav on 11/5/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/tracking_the_force_of_3d_touch_events

/// Quick Actions
/// https://developer.apple.com/documentation/uikit/uiapplicationshortcutitem
/// Quick Actions system icons
/// https://developer.apple.com/documentation/uikit/uiapplicationshortcuticontype?language=objc
class ViewController: UIViewController {
    
    @IBOutlet private weak var forceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = "0 gram"
        print(text)
        forceLabel.text = text
        
        
//        guard let bundleIdentifier =  Bundle.main.bundleIdentifier else {
//            assertionFailure()
//            return
//        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else {
            assertionFailure()
            return
        }
        
        handleForceTouch(touch)
    }
    
    private func handleForceTouch(_ touch: UITouch) {
        guard #available(iOS 9.0, *), traitCollection.forceTouchCapability == .available else {
            /// Fall back to other non 3D Touch features
            return
        }
        /// Enable 3D Touch features
        
        if touch.force >= touch.maximumPossibleForce {
            let text = "385+ grams"
            print(text)
            forceLabel.text = text
        } else {
            let force = touch.force / touch.maximumPossibleForce
            let grams = force * 385
            let roundGrams = Int(grams)
            
            let text = "\(roundGrams) grams"
            print(text)
            forceLabel.text = text
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let text = "0 gram"
        print(text)
        forceLabel.text = text
    }
}

