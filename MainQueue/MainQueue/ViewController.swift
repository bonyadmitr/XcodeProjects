//
//  ViewController.swift
//  MainQueue
//
//  Created by Bondar Yaroslav on 3/15/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.toBackground {
            DispatchQueue.toMain {
                self.view.backgroundColor = UIColor.lightGray
            }
            DispatchQueue.delay(time: 1) {
                DispatchQueue.toMain {
                    UIView.animate(withDuration: 0.3) {
                        self.view.backgroundColor = UIColor.blue
                    }
                }
            }
            
        }
        
    }
}
