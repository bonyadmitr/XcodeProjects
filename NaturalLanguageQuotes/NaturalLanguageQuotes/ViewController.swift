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


}

