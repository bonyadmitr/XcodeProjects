//
//  NavigationViewController.swift
//  WindowFloating
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = UIViewController()
        vc.view.frame = UIScreen.main.bounds
        vc.view.backgroundColor = UIColor.blue
        viewControllers = [vc]
        vc.title = "Floating"
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(exit))
        topViewController?.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func exit() {
        Floating.isShownOnShake = false
        dismiss(animated: true, completion: nil)
    }
}
