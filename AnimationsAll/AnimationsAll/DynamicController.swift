//
//  DynamicController.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 28.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//


import UIKit

class DynamicController: UIViewController {
    
    @IBOutlet weak var startButton: SomeRoundButton!
    
    var barrier: UIView!
    
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var itemBehavior: UIDynamicItemBehavior!
    var animator: UIDynamicAnimator!
    
    var isStart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDynamics()
    }
    
    func setupDynamics() {
        barrier = UIView(frame: CGRect(x: 0.0, y: 300.0, width: 130.0, height: 20.0))
        barrier.backgroundColor = UIColor.black
        view.addSubview(barrier)
        
        gravity = UIGravityBehavior(items: [startButton])
        gravity.magnitude = 1
        
        collision = UICollisionBehavior(items: [startButton])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        itemBehavior = UIDynamicItemBehavior(items: [startButton])
        itemBehavior.elasticity = 0.6
        
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    @IBAction func actionStartButton(_ sender: SomeRoundButton) {
        
        if isStart {
            animator.removeAllBehaviors()
            collision.removeAllBoundaries()
            
            UIView.animate(withDuration: 0.3) {
                self.startButton.transform = CGAffineTransform.identity
                self.startButton.layoutIfNeeded()
            }
        } else {
            animator.addBehavior(gravity)
            animator.addBehavior(itemBehavior)
            animator.addBehavior(collision)
            collision.addBoundary(withIdentifier: "bar" as NSCopying, for: UIBezierPath(rect: barrier.frame))
        }
        isStart = !isStart
    }
}
