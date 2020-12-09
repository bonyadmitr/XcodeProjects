//
//  ViewController.swift
//  KeyboardMultiWindow
//
//  Created by Yaroslav Bondr on 08.12.2020.
//

import UIKit

class ViewController: UIViewController {

    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textField.borderStyle = .roundedRect
        
        let button1 = UIButton(type: .system)
        button1.addTarget(self, action: #selector(onButtonWindow), for: .touchUpInside)
        button1.setTitle("window", for: .normal)
        
        let button2 = UIButton(type: .system)
        button2.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        button2.setTitle("Hide", for: .normal)
    }


}

