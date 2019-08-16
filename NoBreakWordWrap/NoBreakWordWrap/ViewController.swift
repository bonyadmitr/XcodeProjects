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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.text = "sometext\u{00a0}Wi\u{2011}Fi sometext"
        label2.text = "sometext Wi\u{2011}Fi sometext"
        label3.text = "sometext Wi‑Fi sometext"
        label4.text = String(format: "sometext Wi%@Fi sometext", "\u{2011}")
        label5.text = String(format: "sometext Wi%@Fi sometext", "‑")
    }


}

