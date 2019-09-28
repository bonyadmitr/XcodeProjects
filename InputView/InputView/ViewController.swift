//
//  ViewController.swift
//  InputView
//
//  Created by Bondar Yaroslav on 9/28/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

/// can be used UIControl
class InputView: UIView {
    
    private var customInputView: UIView?
    private var customInputAccessoryView: UIView?
    
    override var inputAccessoryView: UIView? {
        return customInputAccessoryView
    }
    
    override var inputView: UIView? {
        return customInputView
    }
    
    override var canBecomeFirstResponder: Bool {
        return inputView != nil
    }
    
    func set(inputView: UIView?, inputAccessoryView: UIView?) {
        customInputView = inputView
        customInputAccessoryView = inputAccessoryView
    }
    
    func addTapGestureToOpenInputView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openInputView))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func closeInputView() {
        resignFirstResponder()
    }
    
    @objc func openInputView() {
        becomeFirstResponder()
    }
}
