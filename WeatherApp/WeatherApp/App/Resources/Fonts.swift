//
//  Fonts.swift
//  Customization
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum Fonts: String {
    case base
    case light
    case bold
}
extension Fonts {
    fileprivate static let baseFontName = "Avenir"
    fileprivate static var baseNameDefault = baseFontName + "-book"
    fileprivate static var lightName = baseFontName + "-light"
    fileprivate static var boldName = baseFontName + "-medium"
    
    private static let baseNameKey = "baseNameFont"
    static var baseName: String {
        get { return UserDefaults.standard.string(forKey: baseNameKey) ?? baseNameDefault }
        set { UserDefaults.standard.set(newValue, forKey: baseNameKey) }
    }
}
extension Fonts {
    static func setNames(base: String? = nil, light: String? = nil, bold: String? = nil) {
        if let base = base {
            Fonts.baseName = base
        }
        if let light = light {
            Fonts.baseName = light
        }
        if let bold = bold {
            Fonts.baseName = bold
        }
    }
}
extension Fonts {
    func font(with size: CGFloat) -> UIFont {
        switch self {
        case .base:
            return UIFont(name: Fonts.baseName, size: size)!
        case .light:
            return UIFont(name: Fonts.lightName, size: size)!
        case .bold:
            return UIFont(name: Fonts.boldName, size: size)!
        }
    }
}

// MARK: - Font for device
extension Fonts {
    func fontForDevice(with size: CGFloat) -> UIFont {
        return font(with: sizeForDevice(with: size))
    }
    
    private func sizeForDevice(with size: CGFloat) -> CGFloat {
        var size = size
        
        //if UIScreen.main.bounds.height == 480 { // iPhone 4
        //    //size += 0
        //} else
        if UIScreen.main.bounds.height == 568 { // IPhone 5
            //size += 0
        } else if UIScreen.main.bounds.width == 375 { // iPhone 6
            size += 3
        } else if UIScreen.main.bounds.width == 414 { // iPhone 6+
            size += 4
        } else if UIScreen.main.bounds.width == 768 { // iPad
            size += 5
        }
        return size
    }
}
