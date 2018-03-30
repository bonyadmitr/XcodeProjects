//
//  ViewController.swift
//  EmptySwiftProject
//
//  Created by Bondar Yaroslav on 16.01.17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitle("OK", for: .normal)
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func buttonPress() {
        print("123")
    }
}

