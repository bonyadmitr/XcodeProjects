//
//  CodeTextField.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 11/28/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import UIKit

//protocol CodeTextFieldDelegate: class {
//    func codeTextField(_ codeTextField: CodeTextField, didEnterCode code: String)
//}

final class CodeTextField: UITextField {
    
    let characterCountLimit = 6
    
    private let underlineColor = UIColor.gray
    private let underlineWidth: CGFloat = 1
    private let bottomBorder = CALayer()
    private let fontKerning = 20
    
//    weak var codeDelegate: CodeTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorder.frame.size.width = layer.frame.width
    }
    
    private func setup() {
        delegate = self
        //textAlignment = .center
        textColor = UIColor.black
        setupBottomBorder()
    }
    
    private func setupBottomBorder() {
        bottomBorder.frame = CGRect(x: 0, y: frame.height - underlineWidth, width: frame.width, height: underlineWidth);
        bottomBorder.backgroundColor = underlineColor.cgColor
        layer.addSublayer(bottomBorder)
    }
    
    private func isAvailableCharacters(in text: String) -> Bool {
        return text.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    private func newLengthFrom(textFieldText: String?, range: NSRange, replacementString string: String) -> Int {
        let startingLength = textFieldText?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        return startingLength + lengthToAdd - lengthToReplace
    }
}

extension CodeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //--- handle length
        let newLength = newLengthFrom(textFieldText: textField.text, range: range, replacementString: string)
        let isNewLengthBigger = newLength > characterCountLimit
        if isNewLengthBigger  {
            return false
        }
        //---
        
        /// if we deleting items
        if string.isEmpty {
//            let remainLength = characterCountLimit - newLength
//            print("remainLength:", remainLength)
            return true
        }
        
        guard isAvailableCharacters(in: string) else {
            return false
        }
        
//        let remainLength = characterCountLimit - newLength
//        print("remainLength:", remainLength)
        
        var typingAttributes = textField.typingAttributes
        typingAttributes?[NSAttributedStringKey.kern.rawValue] = fontKerning
        textField.typingAttributes = typingAttributes
        
        return true
    }
}
