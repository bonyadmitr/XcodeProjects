//
//  ViewController.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
    }
    
    private func isAvailableCharacters(in text: String) -> Bool {
        return text.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return isAvailableCharacters(in: string)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return button")
        return true
    }
}


final class Validators {
    
    /// .*@.*\..*
   static func isEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    /// SELF MATCHES[c]
    /// [c] makes the equality comparison case-insensitive
    static func isValid(email: String) -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$"
        return check(text: email, regEx: emailRegEx)
    }
    
    static func isValid(phone: String) -> Bool {
        var phoneNumber = phone.filter { $0 != "(" && $0 != ")" }
        if !phone.contains("+") {
            phoneNumber = "+" + phoneNumber
        }
        
        let phoneRegEx = "^((\\+)|(00))[0-9]{9,15}$"
        return check(text: phoneNumber, regEx: phoneRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
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
//
//
//let notAvailableCharacterSet = CharacterSet.decimalDigits.inverted
//let result = string.rangeOfCharacter(from: notAvailableCharacterSet)
//return result == nil

