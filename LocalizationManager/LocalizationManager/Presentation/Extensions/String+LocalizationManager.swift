//
//  String+LocalizationManager.swift
//  LocalizationManager
//
//  Created by Bondar Yaroslav on 18/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension String {
    public var localizedBundle: String {
        if let path = Bundle.main.path(forResource: LocalizationManager.shared.currentLanguage, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        print("- not found localized: \(self)")
        return NSLocalizedString(self, comment: "")
    }
    
    public var localizedImage: UIImage? {
        let imageBundle: Bundle
        if let path = Bundle.main.path(forResource: LocalizationManager.shared.currentLanguage, ofType: "lproj") ??
            Bundle.main.path(forResource: LocalizationManager.shared.devLanguage, ofType: "lproj"),
            let bundle = Bundle(path: path)
        {
            imageBundle = bundle
        } else {
            imageBundle = Bundle.main
        }
        
        guard let imagePath = imageBundle.path(forResource: self, ofType: "") else {
            return nil
        }
        
        return UIImage(contentsOfFile: imagePath)
    }
}
