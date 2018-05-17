//
//  KeyboardDismissable.swift
//  OptIn
//
//  Created by Bondar Yaroslav on 5/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol KeyboardDismissable {
    func dismissKeyboard()
}
extension KeyboardDismissable where Self: UIView {
    func dismissKeyboard() {
        endEditing(true)
    }
}
extension KeyboardDismissable where Self: UIViewController {
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
