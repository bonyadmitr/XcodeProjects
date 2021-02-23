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
 
 */

// TODO: CoreML prediction

// TODO: check
// https://github.com/pmtao/SwiftUtilityFramework/blob/master/SwiftUtilityFramework/Foundation/Text/TextTagger.swift
// sort https://github.com/sgigou/ibepo/blob/master/src/keyboard/Services/Autocorrect.swift
// https://stackoverflow.com/a/59032069/5893286
// github search https://github.com/search?l=Swift&q=completions%28forPartialWordRange&type=Code


import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func onInputChanged() {
        guard let input = inputTextField.text else {
            return
        }
        process(input: input)
    }
        func isReal(word: String) -> Bool {
            //let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return misspelledRange.location == NSNotFound
        }
        func misspelled(word: String) -> NSRange {
            //let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return misspelledRange
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
