//
//  ViewController.swift
//  BiometricsManager
//
//  Created by Bondar Yaroslav on 5/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BiometricsManagerImp.printErrors()
    }
}

