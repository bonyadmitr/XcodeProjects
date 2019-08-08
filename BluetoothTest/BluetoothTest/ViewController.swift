//
//  ViewController.swift
//  BluetoothTest
//
//  Created by Yaroslav Bondar on 07/08/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let bluetoothManager = BluetoothManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bluetoothManager.start()
    }


}

let peripheralName = "peripheral ios"
