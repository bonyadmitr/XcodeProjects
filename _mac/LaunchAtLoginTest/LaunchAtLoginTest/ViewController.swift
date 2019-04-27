//
//  ViewController.swift
//  LaunchAtLoginTest
//
//  Created by Bondar Yaroslav on 4/24/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import LaunchAtLogin

class ViewController: NSViewController {
    
    let helperBundleName = "com.by.LaunchAtLoginHelper"
    
    @IBOutlet weak var autoLaunchCheckbox: NSButton!
    
    @IBAction func toggleAutoLaunch(_ sender: NSButton) {
        let isAuto = sender.state == .on
        LaunchAtLogin.isEnabled = isAuto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(LaunchAtLogin.isEnabled)
        
        let foundHelper = LaunchAtLogin.isEnabled
        
        autoLaunchCheckbox.state = foundHelper ? .on : .off
    }
}
