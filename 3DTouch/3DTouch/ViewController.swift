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
/// ru: https://habr.com/post/271291/
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
        
        guard traitCollection.forceTouchCapability == .available else {
            /// Fall back to other non 3D Touch features
            return
        }
        
        /// max number of ShortcutItems (static + dynamic) = 4
        /// static quick actions are shown first, starting at the topmost position in the list
        let newShortcutItem1 = UIApplicationShortcutItem(type: "some1", localizedTitle: "Some 1")
        /// for this needs UIMutableApplicationShortcutItem instead of UIApplicationShortcutItem
        //newShortcutItem1.icon = UIApplicationShortcutIcon(templateImageName: "")
        
        let newShortcutItem2 = UIApplicationShortcutItem(type: "some2", localizedTitle: "Some 2", localizedSubtitle: "Subtitle", icon: UIApplicationShortcutIcon(type: .play), userInfo: nil)
        
        /// don't append. they are saved
        /// beter call this logic only once for first app launch after installation
        print("--- shortcutItems?.count: ", UIApplication.shared.shortcutItems?.count ?? 0)
        UIApplication.shared.shortcutItems = [newShortcutItem1, newShortcutItem2]
        
        /// change existing ShortcutItems
        var shortcutItems = UIApplication.shared.shortcutItems ?? []
        if let existingShortcutItem = shortcutItems.first {
            guard let mutableShortcutItem = existingShortcutItem.mutableCopy() as? UIMutableApplicationShortcutItem
                else { preconditionFailure("Expected a UIMutableApplicationShortcutItem") }
            guard let index = shortcutItems.index(of: existingShortcutItem)
                else { preconditionFailure("Expected a valid index") }

            mutableShortcutItem.localizedTitle = "New Title"
            shortcutItems[index] = mutableShortcutItem
            UIApplication.shared.shortcutItems = shortcutItems
        }

        /// for dynamic quick actions only
        print("---", UIApplication.shared.shortcutItems ?? [])
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
        
        /// #available(iOS 9.0, *)
        guard traitCollection.forceTouchCapability == .available else {
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

