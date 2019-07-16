//
//  ViewController.swift
//  FirebaseTest
//
//  Created by Yaroslav Bondar on 16/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

/// To enable debug logging set the following application argument: -FIRAnalyticsDebugEnabled
///
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("q")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// To disable screen reporting, set the flag FirebaseScreenReportingEnabled to NO (boolean) in the Info.plist
        /// setScreenName:screenClass: must be called after a view controller has appeared
        let screenClass = String(describing: ViewController.self)
        Analytics.setScreenName(screenClass + "Name", screenClass: screenClass)
    }

}

