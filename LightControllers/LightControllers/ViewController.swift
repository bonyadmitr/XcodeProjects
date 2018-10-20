//
//  ViewController.swift
//  LightControllers
//
//  Created by Bondar Yaroslav on 11/4/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KeyboardHandler {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addTapGestureToHideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShowNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        /// #1
        scrollViewBottomConstraint.constant = keyboardFrame.size.height
        view.layoutIfNeeded()
        
        /// #2
        //scrollView.contentInset.bottom = keyboardFrame.size.height
    }
    
    @objc private func keyboardWillHideNotification(notification: NSNotification) {
        /// #1
        scrollViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
        
        /// #2
        //scrollView.contentInset = .zero
    }
}
