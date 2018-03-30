//
//  Fonts.swift
//  ChartsTest
//
//  Created by Yaroslav Bondar on 12.01.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import UIKit

struct Fonts {
    
    private static let baseFontName = "Avenir"
    private static let baseText = baseFontName + "-book"
    private static let lightText = baseFontName + "-light"
    private static let boldText = baseFontName + "-medium"
    
    static func text(with size: CGFloat) -> UIFont {
        return UIFont(name: baseText, size: size)!
    }
    
    static func lightText(with size: CGFloat) -> UIFont {
        return UIFont(name: lightText, size: size)!
    }
    
    static func boldText(with size: CGFloat) -> UIFont {
        return UIFont(name: boldText, size: size)!
    }
    
    // MARK: - For Device
    
    static func textForDevice(with size: CGFloat) -> UIFont {
        return UIFont(name: baseText, size: sizeForDevice(with: size))!
    }
    
    static func lightTextForDevice(with size: CGFloat) -> UIFont {
        return UIFont(name: lightText, size: sizeForDevice(with: size))!
    }
    
    static func boldTextForDevice(with size: CGFloat) -> UIFont {
        return UIFont(name: boldText, size: sizeForDevice(with: size))!
    }
    
    static func sizeForDevice(with size: CGFloat) -> CGFloat {
        var size = size
        
        if UIScreen.main.bounds.height == 480 { // iPhone 4
//            size += 0
        } else if UIScreen.main.bounds.height == 568 { // IPhone 5
//            size += 0
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
