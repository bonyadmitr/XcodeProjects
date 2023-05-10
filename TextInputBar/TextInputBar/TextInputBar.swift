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
}
