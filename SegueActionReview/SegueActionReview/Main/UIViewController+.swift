//
//  UIViewController+.swift
//  SegueActionReview
//
//  Created by Yaroslav Bondar on 02.02.2024.
//

import UIKit

extension UIViewController {
    
    @IBAction private func sharedClose() {
        /// short version `navigationController != nil ? _ = navigationController?.popViewController(animated: true) : dismiss(animated: true)`
        if let navigationController {
#if DEBUG
            let vcs = navigationController.viewControllers
            let vcsCount = vcs.count
            if vcsCount >= 2 {
                print("close pop from: \(String(describing: type(of: vcs[vcsCount - 1]))), to: \(String(describing: type(of: vcs[vcsCount - 2])))")
            } else {
                print("sharedClose pop no action")
            }
#endif
            navigationController.popViewController(animated: true)
            
        } else {
#if DEBUG
            if let presentingViewController {
                print("sharedClose dismiss from: \(String(describing: type(of: self))), to: \(String(describing: type(of: presentingViewController)))")
            } else {
                print("sharedClose dismiss no action")
            }
#endif
            /// doc `presentingViewController?.dismiss(animated: true)`
            dismiss(animated: true)
        }
    }
    
    /**
     not working with xibs
     crash `Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[UIButton sourceViewController]: unrecognized selector sent to instance`
     
     doc https://developer.apple.com/documentation/uikit/resource_management/dismissing_a_view_controller_with_an_unwind_segue
     */
    @IBAction private func sharedUnwind(_ segue: UIStoryboardSegue) {
        print("sharedUnwind from: \(String(describing: type(of: segue.source))), to: \(String(describing: type(of: segue.destination)))")
    }
}
