//
//  ViewController.swift
//  tvOStest
//
//  Created by Bondar Yaroslav on 8/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var testButton: UIButton!
    @IBOutlet private weak var testTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ViewController"
        testTextField.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        return true
    }
}

/// protocol UIFocusEnvironment
extension ViewController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [testButton]
    }
}
