//
//  ViewController.swift
//  TodayExtensionTest
//
//  Created by Bondar Yaroslav on 09/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var someLabel: UILabel!
    @IBOutlet weak var someTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        someLabel.text = String(SharedUserDefaults.shared.shownCounter)
    }
    
    @IBAction func changedSomeTextField(_ sender: UITextField) {
        SharedUserDefaults.shared.someText = sender.text
    }
}
