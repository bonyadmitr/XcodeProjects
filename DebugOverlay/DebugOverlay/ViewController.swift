//
//  ViewController.swift
//  DebugOverlay
//
//  Created by Bondar Yaroslav on 26/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func overlayButtonTapped(_ sender: Any) {
        DebugOverlay.shared.toggleOpen()
    }
}

