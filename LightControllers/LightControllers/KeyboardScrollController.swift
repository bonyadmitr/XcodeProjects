//
//  KeyboardScrollController.swift
//  LightControllers
//
//  Created by Bondar Yaroslav on 26/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class KeyboardScrollController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    convenience init(scrollView: UIScrollView) {
        self.init(nibName: nil, bundle: nil)
        self.scrollView = scrollView
    }
    
    /// will be call from Object in IB and from init(view
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    /// will not be called
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShowNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        //scrollView.contentOffset ///???
        
        
        /// test for scroll offset
        guard let responderView = scrollView.firstResponder as? UIView else {
            return
        }
        
        ///https://github.com/michaeltyson/TPKeyboardAvoiding/blob/master/TPKeyboardAvoiding/UIScrollView%2BTPKeyboardAvoidingAdditions.m
        
        if keyboardFrame.contains(responderView.frame.origin) {
            let scrollPoint = CGPoint(x: 0, y: keyboardFrame.height)
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = scrollPoint
            })
        }
        
        //        if aRect.contains(responderView.frame.origin) == false {
        //            let scrollPoint = CGPoint(x: 0, y: responderView.frame.origin.y - keyboardFrame.height - 100)
        //            scrollView.setContentOffset(scrollPoint, animated: true)
        //        }
    }
    
    @objc private func keyboardWillHideNotification(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}


extension UIView {
    var firstResponder: UIResponder? {
        if isFirstResponder {
            return self
        }
        return subviews.firstResponder
    }
}

extension Collection where Element: UIView {
    var firstResponder: UIResponder? {
        for element in self {
            if let responder = element.firstResponder {
                return responder
            }
        }
        return nil
    }
}

