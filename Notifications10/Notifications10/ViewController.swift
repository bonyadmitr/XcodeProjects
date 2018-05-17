//
//  ViewController.swift
//  Notifications10
//
//  Created by Bondar Yaroslav on 30/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func actionSendButton(_ sender: UIButton) {
        NotificationManager.shared.sendAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
