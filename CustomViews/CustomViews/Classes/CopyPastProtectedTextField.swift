//
//  CopyPastProtectedTextField.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 3/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://stackoverflow.com/questions/29596043/how-to-disable-pasting-in-a-textfield-in-swift
class CopyPastProtectedTextField: UITextField {
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        /// can be used "UIResponderStandardEditActions.copy" instead of "copy(_:)"
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        
        /// don't forget call super or will be available all actions with crashes ("Inser drawing" or others)
        return super.canPerformAction(action, withSender: sender)
    }
}
