//
//  ViewController.swift
//  LightControllers
//
//  Created by Bondar Yaroslav on 11/4/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KeyboardHandler {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addKeyboardController(with: scrollView)
        addKeyboardController()
        view.addTapGestureToHideKeyboard()
    }
}
