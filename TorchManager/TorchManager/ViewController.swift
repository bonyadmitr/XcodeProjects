//
//  ViewController.swift
//  TorchManager
//
//  Created by Bondar Yaroslav on 26/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func actionTorchSlider(_ sender: UISlider) {
        StorageTorchManager.shared?.setTorch(level: sender.value)
    }
    
    @IBAction func actionTorchBarButton(_ sender: UIBarButtonItem) {
        StorageTorchManager.shared?.toggleTorch()
    }
}

