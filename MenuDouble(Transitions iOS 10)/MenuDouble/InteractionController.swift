//
//  InteractionController.swift
//  InteractionTransition
//
//  Created by Bondar Yaroslav on 14/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class InteractionController: UIPercentDrivenInteractiveTransition {
    
    private weak var viewController: UIViewController!
    var shouldCompleteTransition = false
    var transitionInProgress = false
    
    
    func attach(to viewController: UIViewController) {
        self.viewController = viewController
        setupGestureRecognizer(for: viewController.view)
    }
    
    private func setupGestureRecognizer(for view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        
        
        switch gestureRecognizer.state {
        case .began:
            transitionInProgress = true
            _ = viewController.navigationController?.popViewController(animated: true)
//            viewController.dismiss(animated: true, completion: nil)
            
        case .changed:
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
            let progress = CGFloat(min(max(Float(translation.x / 200.0), 0.0), 1.0))
            shouldCompleteTransition = progress > 0.5
            update(progress)
            
        case .cancelled, .ended:
            transitionInProgress = false
            
            if !shouldCompleteTransition || gestureRecognizer.state == .cancelled {
                cancel()
            } else {
                finish()
            }
            
        default:
            print("Unsupported")
        }
    }
}
