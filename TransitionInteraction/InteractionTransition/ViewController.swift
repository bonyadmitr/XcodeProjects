//
//  ViewController.swift
//  InteractionTransition
//
//  Created by Bondar Yaroslav on 14/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit


//class ViewController: UIViewController {
//    let animationController = AnimationController()
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        segue.destination.transitioningDelegate = animationController
//    }
//}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    let animationController = AnimationController()
//    let interactionController = InteractionController()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController2
        vc.transitioningDelegate = vc.transitioning
        vc.transitioning.interactionController.attach(to: vc)
        navigationController?.delegate = vc.transitioning
    }
}

//extension ViewController: UIViewControllerTransitioningDelegate {
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return animationController
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return animationController
//    }
//    
//    
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return interactionController.transitionInProgress ? interactionController : nil
//    }
//    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return interactionController.transitionInProgress ? interactionController : nil
//    }
//}

import UIKit

class ViewController2: UIViewController {
    
    let transitioning = TransitioningDelegate()
    
    
    
}
