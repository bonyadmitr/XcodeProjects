//
//  KeyboardLayoutConstraint.swift
//  NextTextField
//
//  Created by Bondar Yaroslav on 13/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final public class KeyboardLayoutConstraint: NSLayoutConstraint {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShowNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        constant = keyboardFrame.size.height + CGFloat(10)
        layoutIfNeededWithAnimation()
    }
    
    @objc private func keyboardWillHideNotification(notification: NSNotification) {
        constant = 0
        layoutIfNeededWithAnimation()
    }
    
    private func layoutIfNeededWithAnimation() {
        if let view = firstItem as? UIView,
            let superview = view.superview {
            superview.layoutIfNeeded()
        } else if let view = secondItem as? UIView,
            let superview = view.superview {
            superview.layoutIfNeeded()
        }
    }
    
}
