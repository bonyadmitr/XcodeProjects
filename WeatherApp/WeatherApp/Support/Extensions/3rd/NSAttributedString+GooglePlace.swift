//
//  NSAttributedString+GooglePlace.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 07/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import GooglePlaces

extension NSAttributedString {
    var boldGooglePlaceString: NSAttributedString {
        let regularFont = Fonts.base.font(with: 16) //UIFont.systemFont(ofSize: UIFont.labelFontSize)
        let boldFont = Fonts.bold.font(with: 16) //UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        let bolded = mutableCopy() as! NSMutableAttributedString
        let range = NSRange(location: 0, length: bolded.length)
        bolded.enumerateAttribute(NSAttributedStringKey(rawValue: kGMSAutocompleteMatchAttribute), in: range) { (value, range, _) in
            let font = (value == nil) ? regularFont : boldFont
            bolded.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        }
        return bolded
    }
}
