//
//  ViewController.swift
//  TimeMeasurer
//
//  Created by Bondar Yaroslav on 14/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        TimeMeasurer.shared.start()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimeMeasurer.shared.finish(title: "viewDidLoad:")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeMeasurer.shared.finish(title: "viewWillAppear:")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        TimeMeasurer.shared.measure(title: "time:") {
            print("some string", 2*2)
        }
        TimeMeasurer.shared.finish()
    }
}

