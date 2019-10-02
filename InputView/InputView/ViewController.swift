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
        
        addDatePickerView()
        addKeyboardInputView()
    }
    
    private func addDatePickerView() {
        let datePickerView = DatePickerView(frame: .init(x: 50, y: 100, width: 300, height: 100))
        datePickerView.backgroundColor = .systemTeal
        view.addSubview(datePickerView)
    }
    
    private func addKeyboardInputView() {
        
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
