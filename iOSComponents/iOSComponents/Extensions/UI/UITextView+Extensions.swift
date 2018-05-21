//
//  UITextViewExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import UIKit

extension UITextView {
    
    #if os(iOS)
    
    /// EZSE: Automatically adds a toolbar with a done button to the top of the keyboard. Tapping the button will dismiss the keyboard.
    public func addDoneButton(barStyle: UIBarStyle = .Default, title: String? = nil) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: title ?? "Done", style: .Done, target: self, action: #selector(resignFirstResponder))
        ]
        
        keyboardToolbar.barStyle = barStyle
        keyboardToolbar.sizeToFit()
        
        inputAccessoryView = keyboardToolbar
    }
    
    #endif
}
