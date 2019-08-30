//
//  ViewController.swift
//  InfoPlistSecure
//
//  Created by Bondar Yaroslav on 8/29/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        let label = UILabel()
        label.numberOfLines = 0
        view.addSubview(label)
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            label.text = "\(version)"
            print("version is : \(version)")
        }
        
        /// not working for first start
        if let key = Bundle.main.object(forInfoDictionaryKey: "SomeAnalyticsKey") {
            label.text! += "\nkey : \(key)"
            print("key : \(key)")
        } else {
            print("- SomeAnalyticsKey is not set")
        }
        
        label.sizeToFit()
        label.center = view.center
    }


}

