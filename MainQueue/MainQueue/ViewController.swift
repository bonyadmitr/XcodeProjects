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
    
    let vcQueue = DispatchQueue(label: "vcQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// DispatchQueue retain test ---
        let localQueue = DispatchQueue(label: "localQueue")
        let time: DispatchTime = .now() + 3
        
        DispatchQueue.global().asyncAfter(deadline: time) { [weak self] in
            DispatchQueue.global().asyncAfter(deadline: time) {
                localQueue.asyncAfter(deadline: time) {
                    self?.vcQueue.asyncAfter(deadline: time) {
                        DispatchQueue.main.asyncAfter(deadline: time) {
                            self?.view.backgroundColor = UIColor.lightGray
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
