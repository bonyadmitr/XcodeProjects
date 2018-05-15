//
//  ViewController.swift
//  MenuDouble
//
//  Created by Bondar Yaroslav on 14/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class MenuDoubleController: UIViewController {

    @IBOutlet weak var leftContainer: UIView!
    @IBOutlet weak var rightContainer: UIView!
    
    let maxWidth = UIScreen.main.bounds.width - 100
    let mid = UIScreen.main.bounds.width / 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSegue(withIdentifier: "right", sender: nil)
        performSegue(withIdentifier: "left", sender: nil)
        
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        navigationController?.delegate = transitioning
    }
    
    

    
    var interactionInProgress = false
    var shouldCompleteTransition = false
    weak var viewController: UIViewController!
    
    let transitioning = TransitioningDelegate()
    
    @IBAction func actionPanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            let translation = gestureRecognizer.translation(in: rightContainer)
            let q = rightContainer.frame.minX + translation.x
            
            if translation.x < 0 && q < 100 {
                transitioning.interactionController.transitionInProgress = true
                performSegue(withIdentifier: "main", sender: nil)
                return
            }
            
        } else if gestureRecognizer.state == .changed {
        
            let translation = gestureRecognizer.translation(in: rightContainer)
            let q = rightContainer.frame.minX + translation.x
            
            if translation.x < 0 && q < 100 {
                
                let progress = CGFloat(min(max(Float(abs(translation.x) / 200.0), 0.0), 1.0))
                transitioning.interactionController.shouldCompleteTransition = progress > 0.5
                transitioning.interactionController.update(progress)
                
                return
            }
            
            if translation.x > 0 && q > maxWidth { return }
            
            gestureRecognizer.view!.center.x += translation.x
            gestureRecognizer.setTranslation(.zero, in: rightContainer)
        } else {
            
            
            transitioning.interactionController.transitionInProgress = false
            
            if !transitioning.interactionController.shouldCompleteTransition || gestureRecognizer.state == .cancelled {
                transitioning.interactionController.cancel()
            } else {
                transitioning.interactionController.finish()
            }

        
            
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction], animations: {
                if self.rightContainer.frame.minX < self.mid {
                    gestureRecognizer.view!.center.x = 100 + self.rightContainer.bounds.width / 2
                } else {
                    gestureRecognizer.view!.center.x = self.maxWidth + self.rightContainer.bounds.width / 2
                }
            }, completion: nil)
        }
        
        
    }

}
