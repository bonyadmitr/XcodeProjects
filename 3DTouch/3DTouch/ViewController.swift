//
//  ViewController.swift
//  3DTouch
//
//  Created by Bondar Yaroslav on 11/5/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://developer.apple.com/documentation/uikit/peek_and_pop
/// https://developer.apple.com/documentation/uikit/peek_and_pop/implementing_peek_and_pop
/// https://developer.apple.com/documentation/uikit/peek_and_pop/add_home_screen_quick_actions
/// https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/tracking_the_force_of_3d_touch_events

/// Quick Actions
/// https://developer.apple.com/documentation/uikit/uiapplicationshortcutitem
/// ru: https://habr.com/post/271291/
/// Quick Actions system icons
/// https://developer.apple.com/documentation/uikit/uiapplicationshortcuticontype?language=objc
class ViewController: UIViewController {
    
    @IBOutlet private weak var forceLabel: UILabel!
    @IBOutlet private weak var pushFromCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = "0 gram"
        print(text)
        forceLabel.text = text
        
        
        setupShortcutItems()
        registerForPreviewing(with: self, sourceView: pushFromCodeButton)
    }
    
    @IBAction private func pushFromCode(_ sender: UIButton) {
        let vc = PreviewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else {
            assertionFailure()
            return
        }
        
        handleForceTouch(touch)
    }
    
    private func setupShortcutItems() {
        /// max number of ShortcutItems (static + dynamic) = 4
        /// static quick actions are shown first, starting at the topmost position in the list
        
        /// UIApplicationShortcutItem.type is application-specific string, so we don't need to create system-specific string (via bundleIdentifier)
        // TODO: remove from code and info.plist
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            assertionFailure()
            return
        }
        
        guard traitCollection.forceTouchCapability == .available else {
            /// Fall back to other non 3D Touch features
            return
        }
        
        let newShortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).\(Shortcut.some1.rawValue)", localizedTitle: "Some 1")
        /// for this needs UIMutableApplicationShortcutItem instead of UIApplicationShortcutItem
        //newShortcutItem1.icon = UIApplicationShortcutIcon(templateImageName: "")
        
        let newShortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).\(Shortcut.some2.rawValue)", localizedTitle: "Some 2", localizedSubtitle: "Subtitle", icon: UIApplicationShortcutIcon(type: .play), userInfo: nil)
        
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

extension ViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let vc = PreviewController()
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}


import UIKit

final class PreviewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.magenta
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        let action1 = UIPreviewAction(title: "Title 1", style: .default) { _,_ in // [unowned self] (_, _) in /// from appe sample code
            print("--- Title 1")
        }
        
        let action2 = UIPreviewAction(title: "Title 2", style: .selected) { _,_ in // [unowned self] (_, _) in
            print("--- Title 2")
        }
        
        return [action1, action2]
    }

}
