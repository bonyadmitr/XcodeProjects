//
//  TextInputBar.swift
//  TextInputBar
//
//  Created by Yaroslav Bondar on 11.04.2023.
//

import UIKit

final class TextInputBar: UIView, NibInit {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playButton: UIButton!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    private func setup() {
////        autoresizingMask = .flexibleHeight
//
//    }
    
    var onSizeChange: (() -> Void)?
    
    private let font = UIFont.systemFont(ofSize: 16, weight: .regular)
    private let maxNumberOfLines: CGFloat = 6
    
    private lazy var maxHeight: CGFloat = {
        return ceil(font.lineHeight * maxNumberOfLines + textView.textContainerInset.top + textView.textContainerInset.bottom)// + 8 + 8
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.font = font
        placeholderLabel.font = font
        
        /// to remove insets https://stackoverflow.com/a/42333832/5893286
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        
        textView.delegate = self
        
        /// to set height first time
        textViewDidChange(textView)
        
        SpeachManager.shared.onTextChange = { [weak self] text in
            guard let self = self else {
                return
            }
            self.textView.text = text
            self.textViewDidChange(self.textView)
            
            /// move caret to the end on voice recognition
            self.textView.scrollRangeToVisible(NSRange(location: text.count - 1, length: 1))
        }
        SpeachManager.shared.onAutoStop = { [weak self] in
            self?.playButton.isSelected = false
        }
        
    }
    
    private var lastCalculatedHeight: CGFloat = -1
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: bounds.width, height: heightConstraint.constant + 8 + 8) //8 + 8 - top and bottom insets
    }
    
}
