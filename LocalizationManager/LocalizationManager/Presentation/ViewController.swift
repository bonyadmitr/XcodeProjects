//
//  ViewController.swift
//  LocalizationManager
//
//  Created by Bondar Yaroslav on 17/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var someLabel: UILabel! {
        didSet {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .full
            formatter.locale = LocalizationManager.shared.locale
            someLabel.text = formatter.string(from: Date()) 
        }
    }
    
    @IBAction func changeLanguageButton(_ sender: AnyObject) {
        present(languagesSheet, animated: true, completion: nil)
    }
    
    var languagesSheet: UIAlertController {
        let sheetVC = UIAlertController(title: nil, message: "Switch Language".localized, preferredStyle: .actionSheet)
        for language in LanguageManager.shared.availableLanguages {
            let displayName = LanguageManager.shared.displayName(for: language)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: { _ in
                LocalizationManager.shared.set(language: language)
                /// to simplify reload restart app 
                //UIApplication.shared.restart()
            })
            sheetVC.addAction(languageAction)
        }
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        sheetVC.addAction(cancelAction)
        return sheetVC
    }
    
    /// test of memory leak
    deinit {
        print("- deinit ViewController")
    }
}

