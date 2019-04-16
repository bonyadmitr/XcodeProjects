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
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        /// #2
        //scrollView.contentInset.bottom = keyboardFrame.size.height
    }
    
    @objc private func keyboardWillHideNotification(notification: NSNotification) {
        /// #1
        scrollViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        /// #2
        //scrollView.contentInset = .zero
    }
}

final class AdvancedScrollView: UIScrollView {
    func scrollToView(_ view: UIView) {
        let rect = convert(view.frame, to: self)
        scrollRectToVisible(rect, animated: true)
    }
    
    func scrollToViews(_ views: [UIView]) {
        if views.isEmpty {
            return
        }
        
        let rects: [CGRect] = views.map { convert($0.frame, to: self) }
        
        /// check for isEmpty is above
        let firstRect = rects[0]
        let unionRect: CGRect = rects.dropFirst().reduce(into: firstRect) { $0.union($1) }
        
        scrollRectToVisible(unionRect, animated: true)
    }
}

//extension UIScrollView {
//    func scroll(to view: UIView) {
//        let rect = convert(view.frame, to: self)
//        scrollRectToVisible(rect, animated: true)
//    }
//
//    func scroll(to views: [UIView]) {
//        if views.isEmpty {
//            return
//        }
//
//        let rects: [CGRect] = views.map { convert($0.frame, to: self) }
//
//        /// check for isEmpty is above
//        let firstRect = rects[0]
//        let unionRect: CGRect = rects.dropFirst().reduce(into: firstRect) { $0.union($1) }
//
//        scrollRectToVisible(unionRect, animated: true)
//    }
//}
