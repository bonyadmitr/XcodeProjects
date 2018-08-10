//
//  ViewController.swift
//  tvOStest
//
//  Created by Bondar Yaroslav on 8/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ViewController"
    }
}

/// protocol UIFocusEnvironment
extension ViewController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [testButton]
    }
}
