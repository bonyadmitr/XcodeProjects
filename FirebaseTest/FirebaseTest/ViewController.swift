//
//  ViewController.swift
//  FirebaseTest
//
//  Created by Yaroslav Bondar on 16/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import Crashlytics

/// To enable debug logging set the following application argument: -FIRAnalyticsDebugEnabled
/// https://help.apple.com/xcode/mac/8.0/#/dev3ec8a1cb4
///
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("q")
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    @objc func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// To disable screen reporting, set the flag FirebaseScreenReportingEnabled to NO (boolean) in the Info.plist
        ///
        /// setScreenName:screenClass: must be called after a view controller has appeared
        let screenClass = String(describing: ViewController.self)
        Analytics.setScreenName(screenClass + "Name", screenClass: screenClass)
    }

}

