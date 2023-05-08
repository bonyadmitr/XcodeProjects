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
}
