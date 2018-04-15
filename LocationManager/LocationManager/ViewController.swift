//
//  ViewController.swift
//  LocationManager
//
//  Created by Bondar Yaroslav on 2/16/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        BackgroundLocationManager.shared.startUpdateLocation()
        
//        LocationManager.shared.start()
//        
//        LocationManager.shared.didUpdate = { location in
//            print(location)
//        }
    }
}

