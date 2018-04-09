//
//  TextField.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 3/9/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    var shouldAnimateStateChange: Bool = true
    var shouldChangeColorWhenEditing: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        borderStyle = .none
        layer.cornerRadius = 0
        layer.masksToBounds = true
        layer.borderWidth = 1
        tintColor = .black
//        font = UIFont.serifFont(withSize: self.font?.pointSize ?? 26)
        stateChangedAnimated(false)
        setupEvents()
    }
    
    func setupEvents () {
        addTarget(self, action: #selector(TextField.editingDidBegin(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(TextField.editingDidFinish(_:)), for: .editingDidEnd)
    }
    
    @objc func editingDidBegin (_ sender: AnyObject) {
        stateChangedAnimated(shouldAnimateStateChange)
    }
    
    @objc func editingDidFinish(_ sender: AnyObject) {
        stateChangedAnimated(shouldAnimateStateChange)
    }
    
    func stateChangedAnimated(_ animated: Bool) {
        let newBorderColor = borderColorForState().cgColor
        if newBorderColor == layer.borderColor {
            return
        }
        if animated {
            let fade = CABasicAnimation()
            if layer.borderColor == nil { layer.borderColor = UIColor.clear.cgColor }
            fade.fromValue = self.layer.borderColor ?? UIColor.clear.cgColor
            fade.toValue = newBorderColor
            fade.duration =  0.3//AnimationDuration.Short
            layer.add(fade, forKey: "borderColor")
        }
        layer.borderColor = newBorderColor
    }
    
    func borderColorForState() -> UIColor {
        if isEditing && shouldChangeColorWhenEditing {
            return .red
//            return .artsyPurpleRegular()
        } else {
            return .blue
//            return .artsyGrayMedium()
        }
    }
    
    func setBorderColor(_ color: UIColor){
        self.layer.borderColor = color.cgColor
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0 )
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10 , dy: 0 )
    }
}

class SecureTextField: TextField {
    
    var actualText: String = ""
    
    override var text: String! {
        get {
            if isEditing {
                return super.text
            } else {
                return actualText
            }
        }
        
        set {
            super.text = newValue
        }
    }
    
    override func setup() {
        super.setup()
        clearsOnBeginEditing = true
    }
    
    override func setupEvents () {
        super.setupEvents()
        addTarget(self, action: #selector(editingDidChange), for: .editingChanged)
    }
    
    override func editingDidBegin (_ sender: AnyObject) {
        super.editingDidBegin(sender)
        isSecureTextEntry = true
        actualText = text
    }
    
    @objc func editingDidChange(_ sender: AnyObject) {
        actualText = text
    }
    
    override func editingDidFinish(_ sender: AnyObject) {
        super.editingDidFinish(sender)
        isSecureTextEntry = false
        actualText = text
        text = dotPlaceholder()
    }
    
    func dotPlaceholder() -> String {
        var index = 0
        var dots = ""
        while (index < text.count) {
            dots += "•"
            index += 1
        }
        return dots
    }
}

final class SecureTextField2: UITextField {
    
    @IBAction func actionTogglePasswordVisibilityButton(_ sender: UIButton) {
        togglePasswordVisibility()
    }
    
    var saveTextAfterTogglePasswordVisibility = true
    
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry
        updateFont()
        
        if saveTextAfterTogglePasswordVisibility, isSecureTextEntry, let existingText = text {
            /// https://stackoverflow.com/a/48115361/5893286
            /* When toggling to secure text, all text will be purged if the user 
             * continues typing unless we intervene. This is prevented by first 
             * deleting the existing text and then recovering the original text. */
            deleteBackward()
            
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
    }
    
    /// https://stackoverflow.com/a/35295940/5893286
    private func updateFont() {
        let savedFont = font
        font = nil
        font = savedFont
    }
}

final class NumbersTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        delegate = self
    }
    
    private func isAvailableCharacters(in text: String) -> Bool {
        return text.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
extension NumbersTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return isAvailableCharacters(in: string)
    }
}
