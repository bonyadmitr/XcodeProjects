//
//  ReturnButtonHandlingTextField.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 19/04/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://stackoverflow.com/a/46003924/5893286
class ReturnButtonHandlingTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        enablesReturnKeyAutomatically = true
    }
    
    override var hasText: Bool {
        if let text = text, !text.isEmpty {
            return TextHandlers.isNotAllowed(characters: "123qwe", in: text)
        }
        return false
    }
}
