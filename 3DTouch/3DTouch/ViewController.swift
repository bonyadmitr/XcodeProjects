//
//  ViewController.swift
//  3DTouch
//
//  Created by Bondar Yaroslav on 11/5/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// user can turn off 3D Touch while your app is running
/// https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/index.html
/// https://developer.apple.com/documentation/uikit/peek_and_pop
class ViewController: UIViewController {
    
    @IBOutlet private weak var forceLabel: UILabel!
    @IBOutlet private weak var pushFromCodeButton: UIButton!
    
    /// https://developer.apple.com/library/archive/samplecode/AppChat/Introduction/Intro.html
    //@available(iOS 10.0, *)
    //private lazy var previewObject = UIPreviewInteraction(view: pushFromCodeButton)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = "0 gram"
        print(text)
        forceLabel.text = text
        
        // MARK: - Peek and Pop (3d touch preview)
        /// https://developer.apple.com/documentation/uikit/peek_and_pop/implementing_peek_and_pop
        registerForPreviewing(with: self, sourceView: pushFromCodeButton)
        /// don't need manualy
        /// previewVC is result of registerForPreviewing
        /// unregisterForPreviewing(withContext: previewVC)
        
        //if #available(iOS 10.0, *) {
        //    previewObject.delegate = self
        //}
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
    
    /// https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/tracking_the_force_of_3d_touch_events
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
        if previewingContext.sourceView == pushFromCodeButton {
            let vc = PreviewController()
            /// can be setted in storyboard (Use Preferred Explicit Size)
            /// set size for previre vc in 3d touch
            /// set width = 0 to stretch up to the screen width
            vc.preferredContentSize = CGSize(width: 100, height: 100)
            return vc
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

//@available(iOS 10.0, *)
//extension ViewController: UIPreviewInteractionDelegate {
//    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdatePreviewTransition transitionProgress: CGFloat, ended: Bool) {
//        print(transitionProgress)
//    }
//
//    func previewInteractionDidCancel(_ previewInteraction: UIPreviewInteraction) {
//
//    }
//}


import UIKit

final class PreviewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.magenta
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        let action1 = UIPreviewAction(title: "Title 1", style: .default) { action, vc in // [unowned self] (_, _) in /// from appe sample code
            print("--- Title 1")
        }
        
        let action2 = UIPreviewAction(title: "Title 2", style: .destructive) { _,_ in // [unowned self] (_, _) in
            print("--- Title 2")
        }
        
        let group = UIPreviewActionGroup(title: "Group...", style: .default, actions: [action1, action2])
        
        return [group, action1, action2]
    }

}
