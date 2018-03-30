//
//  ColorTypeCompatible.swift
//  Customization
//
//  Created by Bondar Yaroslav on 19/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

/// need to try to do like SnapKit or Kingfisher

//import UIKit
//
//protocol ColorTypeCompatible {
//    var cf: ColorType<Self> { get }
//}
//extension ColorTypeCompatible {
//    var cf: ColorType<Self> {
//        return ColorType(self)
//    }
//}
//
//public struct ColorType<Base> {
//    fileprivate let base: Base
//    public init(_ base: Base) {
//        self.base = base
//    }
//}
//
///// simplified func from(name: String). nothing to add is needed. only new colors
//final class Colors: NSObject {
//    private override init() {}
//}
//extension Colors {
//    static func from(name: String) -> UIColor? {
//        return value(forKey: name) as? UIColor
//    }
//}
//extension Colors {
//    static let main = #colorLiteral(red: 1, green: 0.6731276706, blue: 0.002335626882, alpha: 1)
//    static let dark = #colorLiteral(red: 0.8215842635, green: 0.5486085993, blue: 0.007432873241, alpha: 1)
//}
//
//
//extension ColorType where Base: UILabel {
//    /// #5
//    
//    var textColor: Colors {
//        get { return  }
//        set {
//            
//            guard let color = Colors.from(name: newValue) else {
//                return print("- there is no color type: \(newValue)")
//            }
//            base.textColor =
//        }
//    }
//}
