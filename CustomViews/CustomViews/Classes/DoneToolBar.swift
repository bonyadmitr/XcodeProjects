//
//  DoneToolBar.swift
//  PickerView
//
//  Created by Bondar Yaroslav on 4/3/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

///typealias VoidHandler = () -> Void

/// OR use
//let doneButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(actionKeyboardButtonTapped))
//
//let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//
//let toolBar = UIToolbar()
//toolBar.barStyle = .default
//toolBar.isTranslucent = false
//toolBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
//toolBar.sizeToFit()
//toolBar.isUserInteractionEnabled = true
//toolBar.setItems([flexItem, doneButton], animated: false)
//toolBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
//
//inputAccessoryView = toolBar
final class DoneToolBar: UIToolbar {
    
    var doneButtonTitle: String? {
        didSet {
            doneButton.title = doneButtonTitle 
        }
    }
    var doneAction: VoidHandler?
    
    /// height: 44 - default value of toolBar
    convenience init() {
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        self.init(frame: rect)
    }
    
    /// height: 44 - default value of toolBar
    convenience init(doneButtonTitle: String?, doneAction: @escaping VoidHandler) {
        self.init()
        self.doneButtonTitle = doneButtonTitle
        self.doneAction = doneAction
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private(set) lazy var doneButton = UIBarButtonItem(title: doneButtonTitle, style: .plain, target: self, action: #selector(actionDoneButton))
    
    private func setup() {
        let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        barStyle = .default
        isTranslucent = false
        sizeToFit()
        isUserInteractionEnabled = true
        setItems([flexItem, doneButton], animated: false)
        barTintColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
    }
    
    @objc private func actionDoneButton() {
        doneAction?()
    }
}
