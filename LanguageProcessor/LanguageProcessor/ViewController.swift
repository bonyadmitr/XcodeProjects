//
//  ViewController.swift
//  LanguageProcessor
//
//  Created by Bondar Yaroslav on 6/24/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let languageProcessor = LanguageProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let verbs = languageProcessor.getVerbs(from: "I had gone for a run in the moonlight, then I have seen a unicorn.")
        print("- verbs: \(verbs)")
        
        let sentence1 = "I love eating broccoli"
        let sentence2 = "I don't like eating broccoli"
        
        languageProcessor.getSentimentScore(from: sentence1) { sentimentScore in
            print("- \(sentence1) = \(sentimentScore)")
        }
        languageProcessor.getSentimentScore(from: sentence2) { sentimentScore in
            print("- \(sentence2) = \(sentimentScore)")
        }
    }


}

import NaturalLanguage

/// article https://www.andyibanez.com/posts/analyzing-text-nltagger/
/// article https://medium.com/better-programming/analyse-users-language-in-swift-43e3041c521f
final class LanguageProcessor {
    
    func getVerbs(from stringToRecognize: String) -> [String] {
        var verbsArray: [String] = []
        let range = stringToRecognize.startIndex ..< stringToRecognize.endIndex
        
        let scheme = NLTagScheme.lexicalClass
        let tagger = NLTagger(tagSchemes: [scheme])
        
        tagger.string = stringToRecognize
        tagger.enumerateTags(in: range,
                             unit: .word,
                             scheme: scheme,
                             options: [.omitPunctuation, .omitWhitespace, .joinNames]) { tag, range in
                                
                                if let tag = tag {
                                    print("Word \"\(stringToRecognize[range])\" - \(tag.rawValue)")
                                }
                                
                                
                                if tag?.rawValue == "Verb" {
                                    verbsArray.append(String(stringToRecognize[range]))
                                }
                                
                                return true
        }
        
        return verbsArray
    }

    func getSentimentScore(from stringToRecognize: String, sentimentScore: @escaping (Double) -> Void) {
        DispatchQueue.global().async {
            let range = stringToRecognize.startIndex ..< stringToRecognize.endIndex
            
            let scheme = NLTagScheme.sentimentScore
            let tagger = NLTagger(tagSchemes: [scheme])
            
            tagger.string = stringToRecognize
            tagger.enumerateTags(in: range,
                                 unit: .paragraph,
                                 scheme: scheme,
                                 options: [.omitWhitespace]) { tag, range in
                                    
                                    if let tag = tag, let score = Double(tag.rawValue) {
                                        sentimentScore(score)
                                    } else {
                                        sentimentScore(0)
                                    }
                                    return true
            }
        }

        
    }

}
