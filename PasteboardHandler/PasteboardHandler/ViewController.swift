//
//  ViewController.swift
//  PasteboardHandler
//
//  Created by Bondar Yaroslav on 6/30/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc private func willEnterForeground() {
        
        /// called on first appear
        print("- applicationState", UIApplication.shared.applicationState.rawValue)
        
        /// called on not first appear
        if UIApplication.shared.applicationState == .background {
            print("- willEnterForeground", UIPasteboard.general.string ?? "nil")
        }
    }
    
}
