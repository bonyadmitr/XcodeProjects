//
//  ViewController.swift
//  StateRestorationTest
//
//  Created by Bondar Yaroslav on 21/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// to debug UIStateRestoration do:
/// 1. go to the detail screen
/// 2. press Cmd+Shift+H (home button)
/// 3. stop the app from xcode
/// 4. run the app from xcode
class ViewController: UIViewController {

    @IBOutlet weak var someTextLabel: UILabel!
    
    var someText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        someTextLabel.text = someText
    }
    
    // MARK: - UIStateRestoration
    
    // Constants for state restoration.
    static let restoreProduct = "restoreProductKey"
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        /// example guard
        if someText == "123123" {
            return
        }
        
        coder.encode(someText, forKey: ViewController.restoreProduct)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        /// can be used coder.containsValue(forKey
        if let text = coder.decodeObject(forKey: ViewController.restoreProduct) as? String {
            someText = text
            someTextLabel.text = text
            title = "Decoded"
        }
        else {
            /// if someText == "123123 will pop from detail vc
            _ = navigationController?.popViewController(animated: false)
            
            //or
            //            fatalError("A product did not exist. In your app, handle this gracefully.")
        }
    }
    
    override func applicationFinishedRestoringState() {
        
    }
}

