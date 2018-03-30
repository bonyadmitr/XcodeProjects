//
//  Colors.swift
//  Customization
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

struct Colors {
    private init() {}
    static var main = #colorLiteral(red: 1, green: 0.6731276706, blue: 0.002335626882, alpha: 1)
    static var dark = #colorLiteral(red: 0.8215842635, green: 0.5486085993, blue: 0.007432873241, alpha: 1)
}
extension Colors {
    static func from(name: String) -> UIColor? {
        switch name {
        case "main":
            return main
        case "dark":
            return dark
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
