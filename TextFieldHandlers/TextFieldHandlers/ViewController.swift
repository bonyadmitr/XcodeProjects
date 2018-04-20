//
//  ViewController.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

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
        
        /// if we deleting items
        if string.isEmpty {
            return true
        }
        
        /// text is pasted
        var string = string
        let trimmed = string.trimmed
        if trimmed == UIPasteboard.general.string {
            string = trimmed
        }
        
//        return TextHandlers.isDigits(in: string)
//        return TextHandlers.isAvailableCharacters(in: string)
//        return TextHandlers.isNotAllowed(characters: "123qwe", in: string)
        return TextHandlers.isAllowed(characters: "123qwe", in: string)
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

