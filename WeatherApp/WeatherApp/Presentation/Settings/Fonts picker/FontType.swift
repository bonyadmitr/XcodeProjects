//
//  FontType.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 18/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

enum FontType: Int {
    case all = 0
    case regular
    case light
    case bold
    
    /// old: String(describing: self).capitalized
    var name: String {
        switch self {
        case .all:
            return L10n.all
        case .regular:
            return L10n.regular
        case .light:
            return L10n.light
        case .bold:
            return L10n.bold
        }
    }
    
    var description: String {
        return String(reflecting: self)
    }
}
