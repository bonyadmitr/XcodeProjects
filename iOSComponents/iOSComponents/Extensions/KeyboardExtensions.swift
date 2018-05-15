//
//  KeyboardExtensions.swift
//  Swift3Best
//
//  Created by Bondar Yaroslav on 09.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIViewController {
    public func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
}

extension UIView {
    
    public func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc public func dismissKeyboard() {
        window?.endEditing(true)
    }
}
