//
//  ViewController.swift
//  WindowFloating
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Floating.mode configured in AppDelegate
    }
    
    @IBAction func changedFloatingMode(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            Floating.mode = .button
        } else if sender.selectedSegmentIndex == 1 {
            Floating.mode = .shake
        }  else if sender.selectedSegmentIndex == 2 {
            Floating.mode = .none
        }
    }
    
}
