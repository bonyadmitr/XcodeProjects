//
//  ViewController.swift
//  MainQueue
//
//  Created by Bondar Yaroslav on 3/15/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    deinit {
        print("ViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// DispatchQueue retain test ---
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in 
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { 
                self?.view.backgroundColor = UIColor.lightGray
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popViewController(animated: false)
        }
        /// ---
        
//        DispatchQueue.toBackground {
//            DispatchQueue.toMain {
//                self.view.backgroundColor = UIColor.lightGray
//            }
//            DispatchQueue.delay(time: 1) {
//                DispatchQueue.toMain {
//                    UIView.animate(withDuration: 0.3) {
//                        self.view.backgroundColor = UIColor.blue
//                    }
//                }
//            }
//            
//        }
        
    }
}
