//
//  PlaceholderTextView.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 02/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// idea from: http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
class PlaceholderTextView: UITextView {
    
    @IBInspectable var placeholder: String = ""
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray
    
    fileprivate var savedtextColor: UIColor?
    
    override var text: String! {
        get {
            if super.text == placeholder && textColor == placeholderColor {
                return ""
            }
            return super.text
        }
        set {
            super.text = newValue
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        /// used awakeFromNib
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    /// do not use default 'delegate' or you will break placeholder
    weak var delegateCustom: UITextViewDelegate?
    
    private func setup() {
        savedtextColor = textColor
        setPlaceholder()
        delegate = self
    }
    
    private func setPlaceholder() {
        text = placeholder
        textColor = placeholderColor
        selectedTextRange = textRange(from: beginningOfDocument, to: beginningOfDocument)
    }
}

extension PlaceholderTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Create updated text string
        let currentText = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = placeholder
            textView.textColor = placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                            to: textView.beginningOfDocument)
            return false
        }
            
        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, clear
        // the text view and set its color to black to prepare for
        // the user's entry
        else if textView.textColor == placeholderColor && !text.isEmpty {
            textView.text = ""
            textView.textColor = savedtextColor
        }
        
        return delegateCustom?.textView!(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        /// textViewDidChangeSelection is called before the view loads so need check for window
        if textView.window == nil || textView.textColor != placeholderColor {
            return
        }
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                        to: textView.beginningOfDocument)
        delegateCustom?.textViewDidChangeSelection!(textView)
    }
    
    // MARK: - Custom delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegateCustom?.textViewShouldBeginEditing!(textView) ?? true
    }
    
    @available(iOS 2.0, *)
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return delegateCustom?.textViewShouldEndEditing!(textView) ?? true
    }
    
    
    @available(iOS 2.0, *)
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegateCustom?.textViewDidBeginEditing!(textView)
    }
    
    @available(iOS 2.0, *)
    func textViewDidEndEditing(_ textView: UITextView) {
        delegateCustom?.textViewDidEndEditing!(textView)
    }
    
    @available(iOS 2.0, *)
    func textViewDidChange(_ textView: UITextView) {
        delegateCustom?.textViewDidChange!(textView)
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegateCustom?.textView!(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegateCustom?.textView!(textView, shouldInteractWith: textAttachment, in: characterRange) ?? true
    }
}
