//
//  ViewController.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension ValidatingTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let resultString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string),
            let oldText = textField.text
        {
            
            for validator in validators {
                if let validatorResult = validator.validate(oldText: oldText, newText: string, resultString: resultString),
                    !validatorResult
                {
                    return false
                }
            }
            
            /// all validators true
        }
        
        return true
    }
}


//let str: String = "this-is-my-id"
//
//let result = str.split(separator: "-").reduce("") {(acc, name) in
//    "\(acc)\(acc.count > 0 ? String(name.capitalized) : String(name))"
//}

/// ADD limit for text field
class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var validatingTextField: ValidatingTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        textField.enablesReturnKeyAutomatically = true
        
        validatingTextField.validators = [LimitCharactersValidator(), DeleteValidator(), AvailableCharactersValidator()]
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
        
        /// or 1
        guard TextHandlers.isAllowed(characters: "123qwe", in: string) else {
            return false
        }
        
        let remainLength = characterCountLimit - newLength
        print("remainLength:", remainLength)
        
        return true
        
        /// or 2
//        let isAllowed = TextHandlers.isAllowed(characters: "123qwe", in: string)
//        
//        if isAllowed {
//            let remainLength = characterCountLimit - newLength
//            print("remainLength:", remainLength)
//        }
//        
//        return isAllowed
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return button")
        return true
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

