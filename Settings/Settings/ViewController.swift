//
//  ViewController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

final class SampleDesigner: NSObject {
    @IBOutlet private weak var sampleLabel: UILabel! {
        willSet {
            newValue.text = "language".localized
        }
    }
}
