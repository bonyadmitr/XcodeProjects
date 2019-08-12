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
    private let peripheral = Peripheral()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bluetoothManager.start()
        peripheral.start()
    }


}

let peripheralName = "Peripheral - iOS"
