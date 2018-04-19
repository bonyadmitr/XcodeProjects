//
//  TextHandlers.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 4/19/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// https://grokswift.com/uitextfield/
final class TextHandlers {
    
    static func isDigits(in text: String) -> Bool {
        return text.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    static func isAvailableCharacters(in text: String) -> Bool {
        let characterSetNotAllowed = CharacterSet(charactersIn: "123")
        return text.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) == nil
    }
    
    static func isNotAllowed(characters: String, in text: String) -> Bool {
        let characterSetNotAllowed = CharacterSet(charactersIn: characters)
        return text.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) == nil
    }
    
    static func isAllowed(characters: String, in text: String) -> Bool {
        let characterSetAllowed = CharacterSet(charactersIn: characters)
        
        if let rangeOfCharactersAllowed = text.rangeOfCharacter(from: characterSetAllowed, options: .caseInsensitive) {
            let validCharacterCount = text.distance(from: rangeOfCharactersAllowed.lowerBound,
                                                    to: rangeOfCharactersAllowed.upperBound)
            return validCharacterCount == text.count
        } else  {
            return false
        }
    }
}
