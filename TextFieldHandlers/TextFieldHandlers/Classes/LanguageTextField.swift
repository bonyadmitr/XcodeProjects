//
//  LanguageTextField.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 5/15/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class LanguageTextField: UITextField {
    
    /// UITextInputCurrentInputModeDidChange notification
    /// emoji
    /// ru or ru-RU
    /// en or en-US
    /// UITextInputMode.activeInputModes.forEach { print($0.primaryLanguage)}
    var keyboardLanguage = "en" {
        didSet {
            if isFirstResponder {
                resignFirstResponder()
                becomeFirstResponder()
            }
        }
    }
    
    /// https://stackoverflow.com/a/43636068
    override var textInputMode: UITextInputMode? {
        for textInputMode in UITextInputMode.activeInputModes {
            if textInputMode.primaryLanguage?.contains(keyboardLanguage) == true {
                return textInputMode
            }
        }
        return super.textInputMode
    }
}
