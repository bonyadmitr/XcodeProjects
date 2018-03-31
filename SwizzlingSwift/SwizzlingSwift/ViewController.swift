//
//  ViewController.swift
//  SwizzlingSwift
//
//  Created by Bondar Yaroslav on 21/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        SomeSiwzzable().printSome()
        let _ = UIView()
        
        view.backgroundColor = UIColor.lightGray
    }
    
    deinit {
        print("ViewController deinit")
    }
}
