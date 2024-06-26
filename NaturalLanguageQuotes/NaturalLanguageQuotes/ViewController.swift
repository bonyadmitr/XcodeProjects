//
//  ViewController.swift
//  NaturalLanguageQuotes
//
//  Created by Yaroslav Bondr on 15.02.2021.
//


/**
 Big DB with quotes Natural Language + NLLanguageRecognizer
 https://developer.apple.com/documentation/naturallanguage
 https://www.appcoda.com/natural-language-processing-swift/
 https://www.analyticsvidhya.com/blog/2019/12/create-nlp-apps-ios-using-apples-core-ml-3/
 https://heartbeat.fritz.ai/exploring-word-embeddings-and-text-catalogs-with-apples-natural-language-framework-in-ios-b4d9164f5a3b
 Big Json https://type.fit/api/quotes
 
 Identifying the Language in a Text https://www.createwithswift.com/article-identifying-language-in-text-using-the-natural-language-framework/
 */

// TODO: CoreML prediction

// TODO: check
// https://github.com/pmtao/SwiftUtilityFramework/blob/master/SwiftUtilityFramework/Foundation/Text/TextTagger.swift
// sort https://github.com/sgigou/ibepo/blob/master/src/keyboard/Services/Autocorrect.swift
// https://stackoverflow.com/a/59032069/5893286
// github search https://github.com/search?l=Swift&q=completions%28forPartialWordRange&type=Code


// TODO: Group Similar Titles. improve search results by enabling users to see relevant search results
// https://betterprogramming.pub/crack-coding-interviews-by-building-these-5-real-world-features-4089058d7b0e

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //inputTextField.autocapitalizationType = .sentences
        //inputTextField.autocorrectionType = .yes /// suggestions
        //inputTextField.spellCheckingType = .yes
        inputTextField.delegate = self
        //inputTextField.textContentType = .newPassword
//        inputTextField.autocorrectionType
        
        emojiTest()
        
        resultLabel.text = ""
        inputTextField.becomeFirstResponder()
        
        let text = "how are you going "
        inputTextField.text = text
        process(input: text)
    }
    
    @IBAction private func onInputChanged() {
        guard let input = inputTextField.text else {
            return
        }
        process(input: input)
    }
    
    func process(input: String) {
        
        print("- emojies \(suggestEmoji(for: input))")
        
        
        
//        let input = input.lastWord ?? input
        /// NSSpellChecker https://developer.apple.com/forums/thread/47354
        // print(UITextChecker.availableLanguages)
        /// search problems https://stackoverflow.com/questions/tagged/uitextchecker
        /// `UITextChecker.learnWord("some_word")` + `UITextChecker.unlearnWord("some_word")`
        let checker = UITextChecker()
        
        
        
        func isReal(word: String) -> Bool {
            //let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return misspelledRange.location == NSNotFound
        }
        
        /// get all misspelled  https://www.albertopasca.it/whiletrue/swift-identify-misspelled-words-and-errors-in-phrases/
        func misspelled(word: String) -> NSRange {
            //let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return misspelledRange
        }

        
////        /// nil for empty string
//        let w = checker.completions(forPartialWordRange: NSRange(location: 0, length: input.count), in: input, language: "en_US") ?? []
//        print(w)
//        print()
        
        if input.last == " " {
            /// min 7, max 13
            /// insipred https://developer.apple.com/forums/thread/47354
            
            let input: String = {
                if input.count < 6 {
                    return Array(repeating: " ", count: 6 - input.count) + input
                } else if input.count > 13 {
                    let index = input.index(input.endIndex, offsetBy: -13)
                    return String(input[index...])
                } else {
                    return input
                }
            }()
            
            let augmentedInput = input + " *"
            let range = NSRange(location: input.count, length: -1)
            let completions = checker.completions(forPartialWordRange: range,
                                                  in: augmentedInput,
                                                  language: "en_US") ?? []
            print(completions)
            
            
            
        } else {
            
            
            /// inspired https://github.com/willowtreeapps/vocable-ios/blob/develop/Vocable/Extensions/TextSuggestionController.swift
            let fullExpression = input//.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastWord = input.lastWord
            let range = NSRange(location: fullExpression.count - lastWord.count, length: lastWord.count)
            
            // TODO: do we need utf16.count? https://stackoverflow.com/a/60847716/5893286
            //let range = NSRange(location: fullExpression.utf16.count - lastWord.utf16.count, length: lastWord.utf16.count)
    
            let language = Locale.current.identifier
            
            
            let misspelledRange = misspelled(word: input)
            
            if misspelledRange.location == NSNotFound {
//            if isReal(word: input) {
                /// It will return completed words, but in alphabetical order, not ranked by usage.
                let completions = checker.completions(forPartialWordRange: range, in: fullExpression, language: language) ?? []
                print(completions)
                
            } else {
                /// replacements for a misspelled word
                /// not the same for iOS
                /// The top guess sometimes has quotation marks around it, but other then that it works great
                let guesses = checker.guesses(forWordRange: misspelledRange, in: fullExpression, language: language) ?? []
                print(guesses)
            }

            
            print("-------")
        }
        
        

        
//        let result = completions + guesses
//        print(result)
        
//        if let q = NaturalLanguageManager.shared.emojiForExpression2(input) {
//            resultLabel.text = q.0 + " \(q.1)"
//        } else {
//            resultLabel.text = "-"
//        }
        
        
        //resultLabel.text = input
        //print(input)
    }
    

    
    
    // TODO: mb use https://github.com/safx/Emoji-Swift or https://github.com/maxoumime/emoji-data-ios or https://github.com/integer256/emojimap
    // TODO: localized convertion from https://github.com/unicode-org/cldr/blob/master/common/annotations/en.xml
    // swift CLDR Short Name / apple logic https://stackoverflow.com/a/64038084/5893286
    private let emojiesDesc: [(String, String)] = {
        
        let allEmojies: [String] = {
            let ranges = [
            0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
//            0x1F1E6...0x1F1FF, // Regional country flags
//            0x2600...0x26FF,   // Misc symbols 9728 - 9983
//            0x2700...0x27BF,   // Dingbats
//            0xFE00...0xFE0F,   // Variation Selectors
//            0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs 129280 - 129535
//            0x1F018...0x1F270, // Various asian characters           127000...127600
//            65024...65039, // Variation selector
//            9100...9300, // Misc items
//            8400...8447 // Combining Diacritical Marks for Symbols
            ]
            
            var all = ranges.joined().map {
                return String(Character(UnicodeScalar($0)!))
            }
            
            //⌚️⌨️⭐️
            let solos = [0x231A, 0x231B, 0x2328, 0x2B50]
            all.append(contentsOf: solos.map({ String(Character(UnicodeScalar($0)!))}))
            return all
        }()
        
        return allEmojies.map {
            ($0, $0.unicodeScalars.compactMap { $0.properties.nameAlias ?? $0.properties.name }.joined(separator: " ") )
        }
        
    }()
    
    func suggestEmoji(for text: String) -> [String] {
        
        if text.count == 1 {
            return []
        }
        let text = text.uppercased()
        
        let result = emojiesDesc
            .filter { $0.1.contains(text) }
            //.filter { $0.1.hasPrefix(text) }
            .map { $0.0 }
        
        if text.count == 2, Locale.isoRegionCodes.first(where: { $0 == text}) != nil {
            return [emojiFlag(from: text)] + result
        } else {
            return result
        }
        
        
    }
    
    
    /// ISO2 (two-letter) country code
    /// source https://stackoverflow.com/a/47327408/5893286
    private func emojiFlag(from countryCode: String) -> String {
        /// 0x1F1E6 - "A".unicodeScalars.first!.value == 127397 == UnicodeScalar("🇦").value - UnicodeScalar("A").value
        return String(String.UnicodeScalarView(
            countryCode
                .uppercased()
                .unicodeScalars
                .compactMap { UnicodeScalar(127397 + $0.value) }
        ))
    }
    
    private func emojiTest() {
        
//        let emoji: Character = "🇷🇺"//.description
        let emoji = "🍕" //"\u{1F355}"
//        let emoji = "👨‍👨‍👧‍👧"
//        let emoji = "😄"
        
        let isEmoji = emoji.unicodeScalars.first?.properties.isEmojiPresentation ?? false
        
//        Character(UnicodeScalar($0)!)
        //let emojiInt = emoji.unicodeScalars.first!.value
        let emojiInt = emoji.unicodeScalars.first!.value
        
        
//        let countryList = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
        Locale.isoRegionCodes.forEach {
            print("\($0) - \(Locale.current.localizedString(forRegionCode: $0)!) - \(emojiFlag(from: $0))")
        }
        
        // https://stackoverflow.com/a/53388482/5893286
        if (0x1F1E6...0x1F1FF).contains(emojiInt) {
            
            let code = emoji
                .unicodeScalars
                .compactMap {
                    //REGIONAL INDICATOR SYMBOL LETTER R
                    //REGIONAL INDICATOR SYMBOL LETTER U
                    if let name = $0.properties.nameAlias ?? $0.properties.name, let last = name.last {
                        return String(last)
                    } else {
                        return nil
                    }
                }
                .joined(separator: "")
            print(code)
            
            let counryName = Locale.current.localizedString(forRegionCode: code)!
//            let counryName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: code)!
            //Locale(identifier: code)
            print()
        }
        
        /// inspired https://stackoverflow.com/a/54915809/5893286
//        for scalar in emoji.unicodeScalars {
//            print(scalar.properties.name)
//        }
        
        let w = emoji.unicodeScalars.compactMap { $0.properties.nameAlias ?? $0.properties.name }.joined(separator: "\n")
        print(w)
        
//        if let result = q.applyingTransform(.toUnicodeName, reverse: false) {
//            print(result)
//        }


        print(emoji)
        "pizza"
    }

}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !autoCompleteText(in: textField, using: string, suggestions: ["apple", "apqqq"])
    }
    
    /// article https://gkbrown.org/2017/11/03/implementing-auto-complete-with-uitextfield/
    func autoCompleteText(in textField: UITextField, using string: String, suggestions: [String]) -> Bool {
        if !string.isEmpty,
            let selectedTextRange = textField.selectedTextRange, selectedTextRange.end == textField.endOfDocument,
            let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
            let text = textField.text(in: prefixRange) {
            let prefix = text + string
            let matches = suggestions.filter { $0.hasPrefix(prefix) }

            if (matches.count > 0) {
                textField.text = matches[0]

                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)

                    return true
                }
            }
        }

        return false
    }

    
}

extension String {

    /// inspired https://stackoverflow.com/a/37536996/5893286
    var lastWord: String {
        let cleared = trimmingCharacters(in: .whitespacesAndNewlines)
        if let lastIndex = cleared.lastIndex(of: " "),
           let index = cleared.index(lastIndex, offsetBy: 1, limitedBy: cleared.index(before: cleared.endIndex))
        {
            return String(cleared[index...])
        } else {
            return cleared
        }
        
    }

}






import NaturalLanguage
import CoreML

// macOS only
//import CreateML
//MLGazetteer
// https://developer.apple.com/documentation/createml/mlgazetteer
// https://heartbeat.fritz.ai/exploring-word-embeddings-and-text-catalogs-with-apples-natural-language-framework-in-ios-b4d9164f5a3b

final class NaturalLanguageManager {
    
    static let shared = NaturalLanguageManager()
    
//    func emojiForExpression(_ epxression: String) -> Emotion? {
//        let tagger = NLTagger(tagSchemes: [.sentimentScore])
//        tagger.string = epxression
//
//        if let sentiment = tagger.tag(at: epxression.startIndex, unit: .paragraph, scheme: .sentimentScore).0,
//            let score = Double(sentiment.rawValue) {
//            return Emotion(score: score)
//        }
//        return nil
//    }
    
    
    
////        NSLinguisticTag.placeName == NLTag.placeName
//        let tagger = NLTagger(tagSchemes: [.nameType])
//        tagger.string = text
//        // Ignore Punctuation and Whitespace
//        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
//        // Tags to extract
//        let tags: [NLTag] = [.personalName, .placeName, .organizationName]
//        // Loop over the tokens and print the NER of the tokens
//        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
//            if let tag = tag, tags.contains(tag) {
//                print("\(text[tokenRange]): \(tag.rawValue)")
//            }
//            return true
//        }
    
    /// https://rickwierenga.com/blog/apple/NaturalLanguage.html
    /// https://github.com/rickwierenga/NaturalLanuage/blob/master/NaturalLanguage.playground/Contents.swift
    func emojiForExpression2(_ epxression: String) -> (String, Double)? {
        
        
//        let embedding = NLEmbedding.wordEmbedding(for: .english)!
//        embedding.enumerateNeighbors(for: epxression.lowercased(), maximumCount: 5) { string, distance in
//            print("\(string) - \(distance)")
//            return true
//        }
//        print("---------------")
        
        /// you can store it. and it will be another results
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        
        tagger.string = epxression
        
        /// Changing the unit to word or sentence would not work
        if let sentiment = tagger.tag(at: epxression.startIndex, unit: .paragraph, scheme: .sentimentScore).0,
           let score = Double(sentiment.rawValue),
           let emotion = Emotion(score: score)
        {
            return (emotion.rawValue, score)
        }
        return nil
    }
    
}

enum Emotion: String {
    case superSad = "😭"
    case sad = "😢"
    case unhappy = "😕"
    case OK = "🙂"
    case happy = "😁"
    case awesome = "🤩"
    
    init?(score: Double) {
        if score < -0.8 {
            self = .superSad
        } else if score < -0.4 {
            self = .sad
        } else if score < 0 {
            self = .unhappy
        } else if score < 0.4 {
            self = .OK
        } else if score < 0.8 {
            self = .happy
        } else if score <= 1 {
            self = .awesome
        } else {
            return nil
        }
    }
    
    //            let emoji: String
    //            switch score {
    //            case -1 ..< -0.8:
    //                emoji = "😭"
    //            case -0.8 ..< -0.4:
    //                emoji = "😢"
    //            case -0.4 ..< 0:
    //                emoji = "🙂"
    //            case 0 ..< 0.4:
    //                emoji = "🙂"
    //            case 0.4 ..< 0.8:
    //                emoji = "😁"
    //            case 0.8 ... 1:
    //                emoji = "🤩"
    //            default:
    //                assertionFailure()
    //                emoji = ""
    //            }
    
    
}
