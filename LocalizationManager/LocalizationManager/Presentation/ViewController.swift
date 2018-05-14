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
    
    @IBOutlet private weak var flagImageView: UIImageView! {
        didSet {
            flagImageView.image = "flag.png".localizedImage
        }
    }
    
    @IBOutlet private weak var arrowImageView: UIImageView! {
        didSet {
            arrowImageView.image = #imageLiteral(resourceName: "arrow").flippedForRTLIfNeed
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// to remove navigation bar shadow on back action
        /// https://stackoverflow.com/questions/22413193/dark-shadow-on-navigation-bar-during-segue-transition-after-upgrading-to-xcode-5
        navigationController?.view.backgroundColor = UIColor.white
    }
    
    /// test of memory leak
    deinit {
        print("- deinit ViewController")
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
    
    @IBAction func changeLanguageButton(_ sender: AnyObject) {
        present(languagesSheet, animated: true, completion: nil)
    }
    
    @IBAction private func restartApp(_ sender: UIButton) {
        UIApplication.shared.restart()
    }
}

