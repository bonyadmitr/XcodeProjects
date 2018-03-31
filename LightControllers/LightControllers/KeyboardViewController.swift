//
//  KeyboardViewController.swift
//  LightControllers
//
//  Created by Bondar Yaroslav on 26/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// can be used as NSObject with IBOutlet upView
/// http://khanlou.com/2016/02/many-controllers/
final class KeyboardViewController: UIViewController {
    
    @IBOutlet private weak var upView: UIView?
    
    private lazy var height: CGFloat = {
        return upView?.frame.size.height ?? 0
    }()
    
    convenience init(view: UIView) {
        self.init(nibName: nil, bundle: nil)
        upView = view
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            
        }) { (context) in
//            self.updateView(with: self.height)
        }
        
    }
    
    @objc private func keyboardWillShowNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        updateView(with: height - keyboardFrame.height)
    }
    
    @objc private func keyboardWillHideNotification(notification: NSNotification) {
        updateView(with: height)
    }
    
    private func updateView(with height: CGFloat) {
        upView?.frame.size.height = height
        UIView.animate(withDuration: 0.3) {
            self.upView?.layoutIfNeeded()
        }
    }
}
