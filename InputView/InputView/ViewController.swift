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
        
        let datePickerView = DatePickerView(frame: .init(x: 50, y: 100, width: 300, height: 100))
        datePickerView.backgroundColor = .systemTeal
        view.addSubview(datePickerView)
        
        let toolBar: UIToolbar = {
            let toolBar = UIToolbar()
            toolBar.isTranslucent = false
            
            /// background color
            toolBar.barTintColor = .systemTeal
            
            /// buttons color
            toolBar.tintColor = .white
            
            /// to fix breaking constraints
            toolBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
            
            toolBar.items = [.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                             .init(title: "Done", style: .plain, target: view, action: #selector(view.endEditing(_:)))]
            
            /// update toolBar.frame.height to system one. defalut 44
            toolBar.sizeToFit()
            
            return toolBar
        }()
        
        let keyboardInputView = KeyboardInputView(frame: .init(x: 50, y: 300, width: 300, height: 100))
        keyboardInputView.backgroundColor = .systemPink
        keyboardInputView.keyboardType = .phonePad
        keyboardInputView.set(inputView: nil, inputAccessoryView: toolBar)
        view.addSubview(keyboardInputView)
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
                         .init(title: "Done", style: .plain, target: self, action: #selector(endEditing(_:)))]
        
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

// TODO: add another methods from UITextInputTraits
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
