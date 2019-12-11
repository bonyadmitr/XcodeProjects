//
//  DetailViewController.swift
//  Notes
//
//  Created by Yaroslav Bondar on 11.12.2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var bodyTextView: UITextView!

    var detailItem: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        bodyTextView.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let detailItem = detailItem else {
            assertionFailure()
            return
        }
        if detailItem.body != bodyTextView.text {
            detailItem.body = bodyTextView.text
            try? detailItem.managedObjectContext?.save()
        } else {
            detailItem.managedObjectContext?.delete(detailItem)
        }
    }
    
    private func configureView() {
        if let detail = detailItem {
            bodyTextView.text = detailItem?.body
        }
    }

}


import UIKit

@available(tvOS, unavailable)
@available(macCatalyst, unavailable)
final public class KeyboardLayoutConstraint: NSLayoutConstraint {
    
    /// used class var bcz instance var = 0
    static let tabBarHeight: CGFloat = 49
    
    @IBInspectable public var keyboardInset: CGFloat = 1000
    @IBInspectable public var initialInset: CGFloat = 0
    @IBInspectable public var isTabBar: Bool = false
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShowNotification(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        constant = keyboardFrame.size.height + keyboardInset
        if isTabBar {
            constant -= KeyboardLayoutConstraint.tabBarHeight
        }
        if Device.isIphoneX {
            // TODO: safeAreaInsets.bottom
            constant -= 34
        }
        layoutIfNeededWithAnimation()
    }
    
    @objc private func keyboardWillHideNotification(_ notification: NSNotification) {
        constant = initialInset
        layoutIfNeededWithAnimation()
    }
    
    private func layoutIfNeededWithAnimation() {
        /// 1. view.window or view.superview ???
        /// 2. maybe there is a better way to update layout
        if let view = secondItem as? UIView, let superview = view.superview {
            superview.layoutIfNeeded()
        } else if let view = firstItem as? UIView, let superview = view.superview {
            superview.layoutIfNeeded()
        }
    }
}

enum Device {
    /// https://stackoverflow.com/questions/46192280/detect-if-the-device-is-iphone-x
    static var isIphoneX: Bool {
        return (UIDevice.current.userInterfaceIdiom == .phone) && (UIScreen.main.bounds.height >= 812)
    }
}
