//
//  ViewController.swift
//  PresentVC
//
//  Created by Yaroslav Bondar on 25.05.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        presentDismissAnimationFix()
        
        /// remove FixedNavigationController from Main.storyboard
        
//        //CATransaction.commit()
//        CATransaction.begin()
//        CATransaction.setCompletionBlock {
//            print("- setCompletionBlock 1")
//        }
//        CATransaction.begin()
//        CATransaction.setCompletionBlock {
//            print("- setCompletionBlock 2")
//        }
//        pushCrash()
//        CATransaction.setCompletionBlock {
//            print("- setCompletionBlock 3")
//        }
//        CATransaction.commit()
//        CATransaction.commit()
        
        
//        pushCrash2()
//        pushCrash3()
        
        
    }

}
