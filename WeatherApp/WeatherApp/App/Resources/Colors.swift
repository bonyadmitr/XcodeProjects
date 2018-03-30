//
//  Colors.swift
//  Customization
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum Colors {
    static var mainDefault = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    static var text = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static var imageDark = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    private static let mainColorKey = "mainColorKey"
    static var main: UIColor {
        get { return UserDefaults.standard.color(forKey: mainColorKey) ?? mainDefault }
        set { UserDefaults.standard.set(newValue, forKey: mainColorKey) }
    }
}
extension Colors {
    static func from(name: String) -> UIColor? {
        switch name {
        case "main":
            return main
        case "text":
            return text
        case "imageDark":
            return imageDark
        default:
            return nil
        }
    }
}

//final class Colors: NSObject {
//    static func from(name: String) -> UIColor? {
//        return value(forKey: name) as? UIColor
//    }
//}
//extension Colors {
//    static var main = #colorLiteral(red: 1, green: 0.6731276706, blue: 0.002335626882, alpha: 1)
//    static var dark = #colorLiteral(red: 0.8215842635, green: 0.5486085993, blue: 0.007432873241, alpha: 1)
//}
