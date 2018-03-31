//
//  NextTextField.swift
//  LightControllers
//
//  Created by Bondar Yaroslav on 13/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

open class NextTextField: UITextField {
    
    @IBOutlet open weak var nextUIResponder: UIResponder?
    
    @IBInspectable open var addNextToolbar: Bool = false {
        didSet { addKeyboardNextToolbar() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        /// can be added
        //keyboardType = .numberPad
        //returnKeyType = .next
        addTarget(self, action: #selector(actionKeyboardButtonTapped), for: .editingDidEndOnExit)
    }
    
    @objc private func actionKeyboardButtonTapped() {
        switch nextUIResponder {
        case let button as UIButton where button.isEnabled:
            /// can be added
            //resignFirstResponder()
            button.sendActions(for: .touchUpInside)
        case .some(let responder):
            responder.becomeFirstResponder()
        default:
            resignFirstResponder()
        }
    }
    
    private func addKeyboardNextToolbar() {
        let doneButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(actionKeyboardButtonTapped))
        
        let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        toolBar.setItems([flexItem, doneButton], animated: false)
        toolBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        
        inputAccessoryView = toolBar
    }
}
