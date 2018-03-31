//
//  KeyboardHideManager.swift
//  NextTextField
//
//  Created by Bondar Yaroslav on 13/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final public class KeyboardHideManager: NSObject {
    
    /// Here will be saved targets added from IB
    @IBOutlet internal var targets: [UIView]! {
        didSet {
            targets.forEach { addGesture(to: $0) }
        }
    }
    
    /// if true will apply gesture to view without subviews
    @IBInspectable internal var scrollSupport: Bool = true
    
    /// Add UITapGestureRecognizer with action dismissKeyboard
    /// - Parameter target: A target that will be used to add gesture
    internal func addGesture(to target: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        target.addGestureRecognizer(gesture)
        if scrollSupport {
            gesture.cancelsTouchesInView = false
            gesture.delegate = self
        }
    }
    
    /// Execute endEditing(true) for top superview to hide keyboard
    @objc internal func dismissKeyboard() {
        targets.first?.window?.endEditing(true)
    }
}

extension KeyboardHideManager: UIGestureRecognizerDelegate {
    
    /// need for scrollSupport
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer.view == touch.view {
            return true
        }
        return false
    }
}
