//
//  ViewController.swift
//  UIComponents
//
//  Created by Bondar Yaroslav on 5/31/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

class RoundedProgressView: UIProgressView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.midY
        layer.masksToBounds = true
    }
}
