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
        label.center = view.center
        view.addSubview(label)
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            label.text = "\(version)"
            label.sizeToFit()
            print("version is : \(version)")
        }
    }


}

