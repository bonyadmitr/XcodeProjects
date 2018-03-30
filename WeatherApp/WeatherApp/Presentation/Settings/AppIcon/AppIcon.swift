//
//  AppIcon.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 22/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// Enum of icons that you must change
enum AppIcon: String {
    case primary
    case clear
    case rain
    case clouds
    
    /// all enum values
    static let allValues = [primary, clear, rain, clouds]
    
    /// get name for UIApplication.shared.setAlternateIconName
    /// primary must be nil
    var name: String? {
        switch self {
        case .primary:
            return nil
        default:
            return self.rawValue
        }
    }
    
    /// get UIImage from enum
    var image: UIImage {
        switch self {
        case .primary:
            return UIApplication.shared.appIcon ?? UIImage()
        default:
            return UIImage(named: self.rawValue)!
        }
    }
}
