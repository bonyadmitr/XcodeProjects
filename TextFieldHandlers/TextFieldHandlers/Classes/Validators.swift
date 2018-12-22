//
//  Validators.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 4/19/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// CHECK NumberFormatter
final class Validators {
    
    /// https://www.regextester.com/
    //
    /// https://stackoverflow.com/a/39550723/5893286
    //let regex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
    //    "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
    //    "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
    //    "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
    //    "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
    //    "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
    //"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    //
    /// .*  - 0 or any number
    /// .+  - 1 or any number
    /// "\\" used only for iOS string. it is "\"
    /// "$" used only for iOS string
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
