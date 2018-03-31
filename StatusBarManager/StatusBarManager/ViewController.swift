//
//  ViewController.swift
//  StatusBarManager
//
//  Created by Bondar Yaroslav on 07/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ViewController: StatusBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarManager.animationDuration = 1
        statusBarManager.updateAnimation = .slide
        statusBarManager.isHidden = true
    }
    
    @IBAction func actionStatusBarSwitch(_ sender: UISwitch) {
        statusBarManager.isHidden = !statusBarManager.isHidden
    }
}

