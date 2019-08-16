//
//  ViewController.swift
//  NoBreakWordWrap
//
//  Created by Bondar Yaroslav on 8/16/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var label1: UILabel!
    @IBOutlet private weak var label2: UILabel!
    @IBOutlet private weak var label3: UILabel!
    @IBOutlet private weak var label4: UILabel!
    @IBOutlet private weak var label5: UILabel!
    @IBOutlet private weak var label6: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.text = "sometext\u{00a0}Wi\u{2011}Fi sometext"
        label2.text = "sometext Wi\u{2011}Fi sometext"
        label3.text = "sometext Wi‑Fi sometext"
        
        label4.text = String(format: NSLocalizedString("sometext_wifi_param", comment: ""), "\u{2011}")
        
        /// not working \u{2011} in Localizable.strings
        label5.text = NSLocalizedString("sometext_wifi_sold1", comment: "")
        
        label6.text = NSLocalizedString("sometext_wifi_sold2", comment: "")
    }


}

