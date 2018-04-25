//
//  ViewController.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

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

/// ADD limit for text field
class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        textField.enablesReturnKeyAutomatically = true
    }
}

extension String {
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //--- handle length
        /// !!! create for pasting to limit
        /// create classes
        // limit to 4 characters
        let characterCountLimit = 4
        
        // We need to figure out how many characters would be in the string after the change happens
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        let isNewLengthBigger = newLength > characterCountLimit
        
        if isNewLengthBigger {
            return false
        }
        
        //---
        
        /// if we deleting items
        if string.isEmpty {
            let remainLength = characterCountLimit - newLength
            print("remainLength:", remainLength)
            return true
        }
        
        
        /// text is pasted
        /// 1
        /// or string.count > 1
        /// 2
        ///UIPasteboard.general.string?.contains(string) == true
        /// 3
        /// there are whitespaces in "string" after copy&past
        var string = string
        let trimmed = string.trimmed
        if trimmed == UIPasteboard.general.string {
            string = trimmed
        }
        
//        return TextHandlers.isDigits(in: string)
//        return TextHandlers.isAvailableCharacters(in: string)
//        return TextHandlers.isNotAllowed(characters: "123qwe", in: string)
        let isAllowed = TextHandlers.isAllowed(characters: "123qwe", in: string)
        
        if isAllowed {
            let remainLength = characterCountLimit - newLength
            print("remainLength:", remainLength)
        }
        
        return isAllowed
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return button")
        return true
    }
}

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


//replaceSubrange
//https://stackoverflow.com/a/48581912/5893286

//private func isAvailableCharacters(in text: String) -> Bool {
//    return text.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
//}
//
//func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//    guard isAvailableCharacters(in: string) else {
//        return false
//    }
//    if textField.text?.isEmpty == true {
//        textField.text = "+"
//    }
//    
//    if let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string), newString.isEmpty {
//        doneButton.isEnabled = false
//    } else {
//        doneButton.isEnabled = true
//    }
//    
//    return true
//}

