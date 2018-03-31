//
//  ViewController.swift
//  Appearance
//
//  Created by zdaecqze zdaecq on 24.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        label.text = "\u{f037}"
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.barStyle = .black
    }
    
    @IBAction func backToVc1(sender: UIStoryboardSegue) {}
}

class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}

class ViewController3: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        doneButton.tintColor = UIColor.cyan
    }
}
