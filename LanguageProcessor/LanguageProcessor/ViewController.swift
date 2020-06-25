//
//  ViewController.swift
//  LanguageProcessor
//
//  Created by Bondar Yaroslav on 6/24/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

import NaturalLanguage

final class LanguageProcessor {
    
    func getVerbs(from stringToRecognize: String, verbs: ([String]) -> Void) {
        
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
        
        verbs(verbsArray)
    }

    func getSentimentScore(from stringToRecognize: String, sentimentScore: (Double) -> Void) {
        
        let range = stringToRecognize.startIndex ..< stringToRecognize.endIndex
        
        let scheme = NLTagScheme.sentimentScore
        let tagger = NLTagger(tagSchemes: [scheme])
        
        tagger.string = stringToRecognize
        tagger.enumerateTags(in: range,
                             unit: .paragraph,
                             scheme: scheme,
                             options: [.omitWhitespace]) { tag, range in
                                
                                let score = Double(tag?.rawValue ?? "") ?? 0
                                sentimentScore(score)
                                return true
        }
        
    }

}
