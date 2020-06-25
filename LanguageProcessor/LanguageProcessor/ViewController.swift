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
