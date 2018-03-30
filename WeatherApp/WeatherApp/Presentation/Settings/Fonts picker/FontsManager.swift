//
//  FontsManager.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 18/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class FontsManager {
    
    static let shared = FontsManager()
    
    lazy var familyNames: [String] = UIFont.familyNames.sorted()
    
    //    var fontFamiliesAll: [FontFamily] = []
    //    var fontFamilies: [FontFamily] = []
    
    func fontFamilies(for type: FontType = .all) -> [FontFamily] {
        var fontNames: [[String]]!
        
        switch type {
        case .all:
            fontNames = familyNames
                .map { UIFont.fontNames(forFamilyName: $0) }
        case .regular:
            fontNames = familyNames
                .map { UIFont.fontNames(forFamilyName: $0) }
                .map { $0.filter { $0.contains("Regular") } }
            
        case .light:
            fontNames = familyNames
                .map { UIFont.fontNames(forFamilyName: $0) }
                .map { $0.filter { $0.contains("Light") } }
        case .bold:
            fontNames = familyNames
                .map { UIFont.fontNames(forFamilyName: $0) }
                .map { $0.filter { $0.contains("Bold") || $0.contains("Medium") } }
        }
        
        //        fontFamiliesAll =
        //        fontFamilies = fontFamiliesAll
        return zip(familyNames, fontNames).map { (family, fonts) in
            FontFamily(name: family, fonts: fonts)
        }.filter { $0.fonts.notEmpty }
    }
    
    //    func fontFamilies(for searchText: String) -> [FontFamily] {
    //        fontFamilies = fontFamiliesAll.filter { $0.name.contains(searchText)}
    //        return fontFamilies
    //    }
}
