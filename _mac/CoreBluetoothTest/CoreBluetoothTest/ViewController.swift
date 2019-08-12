//
//  ViewController.swift
//  CoreBluetoothTest
//
//  Created by Yaroslav Bondar on 07/08/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    private let bluetoothManager = BluetoothManager()
    private let central = Central()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        central.start()
        //bluetoothManager.start()
        
        //UUID().uuidString
//        "7D985539-2133-44E6-AD37-67E62CA3CD97"
//        "BAB12052-9934-4D29-8858-E2DEAC3E28BD"
        
        
    }
    
}

let peripheralName = "peripheral mac"
