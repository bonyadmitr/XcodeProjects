//
//  ValidatingTextField.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 15/05/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ValidatingTextField: UITextField {
    
    var validators: [TFValidator] = []
    
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
}

// MARK: - TFValidator

protocol TFValidator {
    func validate(oldText: String, newText: String, resultString: String) -> Bool?
}

final class AvailableCharactersValidator: TFValidator {
    func validate(oldText: String, newText: String, resultString: String) -> Bool? {
        return TextHandlers.isNotAllowed(characters: "123qwe", in: newText)
    }
}

final class LimitCharactersValidator: TFValidator {
    func validate(oldText: String, newText: String, resultString: String) -> Bool? {
        let characterCountLimit = 4
        return resultString.count <= characterCountLimit
    }
}

final class DeleteValidator: TFValidator {
    func validate(oldText: String, newText: String, resultString: String) -> Bool? {
        if newText.isEmpty {
            return true
        }
        return nil
    }
}
