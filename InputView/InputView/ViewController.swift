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
        assert(window != nil, "Never call becomeFirstResponder() on a view that is not part of an active view hierarchy")
        becomeFirstResponder()
    }
}

final class DatePickerView: InputView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addTapGestureToOpenInputView()
        set(inputView: datePicker, inputAccessoryView: toolBar)
    }
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.isTranslucent = false
        
        /// background color
        toolBar.barTintColor = .systemTeal
        
        /// buttons color
        toolBar.tintColor = .white
        
        /// to fix breaking constraints
        toolBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
        
        toolBar.items = [.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         .init(title: "Done", style: .plain, target: self, action: #selector(closeInputView))]
        
        /// update toolBar.frame.height to system one. defalut 44
        toolBar.sizeToFit()
        
        return toolBar
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        /// can be set
        datePicker.frame.size.height = 300
        
        datePicker.backgroundColor = .systemTeal
        
        /// UIDatePicker text color https://stackoverflow.com/a/35493387/5893286
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.sendAction(Selector(("setHighlightsToday:")), to: nil, for: nil)
        
        return datePicker
    }()
}

final class KeyboardInputView: InputView, UITextInputTraits {
    
    var text = ""
    
    /// keyboardType works without adopting UITextInputTraits
    var keyboardType: UIKeyboardType = .default
    
    var textDidChange: ((String) -> Void)?
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addTapGestureToOpenInputView()
    }
}

extension KeyboardInputView: UIKeyInput {
    
    var hasText: Bool {
        return !text.isEmpty
    }
    
    func insertText(_ text: String) {
        self.text.append(text)
        textDidChange?(self.text)
    }
    
    func deleteBackward() {
        text.removeLast()
        textDidChange?(self.text)
    }
}
