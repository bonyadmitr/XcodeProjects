//
//  LanguageTextFieldController.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 5/15/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class LanguageTextFieldController: UIViewController {
    
    @IBOutlet weak var languageTextField: LanguageTextField!
    
    @IBAction private func languageDidChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            languageTextField.keyboardLanguage = "en"
        } else if sender.selectedSegmentIndex == 1 {
            languageTextField.keyboardLanguage = "emoji"
        }
    }
}
