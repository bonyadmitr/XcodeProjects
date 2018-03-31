//
//  ViewController.swift
//  Transitions
//
//  Created by Bondar Yaroslav on 24/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PushAnimator" {
            let vc = segue.destination as! ViewController2
            vc.transitioning = TransitioningDelegate(animator: PushAnimator())
            vc.transitioningDelegate = vc.transitioning
            
        } else if segue.identifier == "FlipAnimator" {
            let vc = segue.destination as! ViewController2
            vc.transitioning = TransitioningDelegate(animator: FlipAnimator())
            vc.transitioningDelegate = vc.transitioning
        }
    }
}

import UIKit

class ViewController2: UIViewController {
    var transitioning: TransitioningDelegate!
}
