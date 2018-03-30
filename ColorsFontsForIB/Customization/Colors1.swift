////
////  Colors.swift
////
////  Colors.swift
////  Customization
////
////  Created by Yaroslav Bondar on 12.01.17.
////  Copyright © 2017 Yaroslav Bondar. All rights reserved.
////
//
//import UIKit

//extension UILabel {
//    
//    /// #1
//    @available(*, unavailable, message: "This property is reserved for Interface Builder")
//    @IBInspectable public var colorType: String {
//        get { return "" }
//        set {
//            guard let type = ColorType(rawValue: newValue) else {
//                return print("- there is no color type: \(newValue)")
//            }
//            textColor = type.value
//        }
//    }
//    
//    /// #2
//    @available(*, unavailable, message: "This property is reserved for Interface Builder")
//    @IBInspectable public var colorType2: String {
//        get { return "" }
//        set {
//            guard let color = Colors.from(name: newValue) else {
//                return print("- there is no color type: \(newValue)")
//            }
//            textColor = color
//        }
//    }
//    
//    /// #3
//    @IBInspectable public var colorType3: String? {
//        get {
//            guard let type = ColorType2(color: textColor) else {
//                return nil
//            }
//            return type.rawValue
//        }
//        set {
//            guard let value = newValue, let type = ColorType2(rawValue: value) else {
//                return print("- there is no color type: \(newValue ?? "nil")")
//            }
//            textColor = type.value
//        }
//    }
//    
//    /// #4
//    @available(*, unavailable, message: "This property is reserved for Interface Builder")
//    @IBInspectable public var colorType4: String {
//        get { return "" }
//        set {
//            guard let type = ColorType3(rawValue: newValue) else {
//                return print("- there is no color type: \(newValue)")
//            }
//            textColor = type.value
//        }
//    }
//    
//    /// #5
//    @available(*, unavailable, message: "This property is reserved for Interface Builder")
//    @IBInspectable public var colorType5: String {
//        get { return "" }
//        set {
//            guard let color = Colors2.from(name: newValue) else {
//                return print("- there is no color type: \(newValue)")
//            }
//            textColor = color
//        }
//    }
//}
//
//
//
//import UIKit
//
///// #1
///// there is no stored colors like in Colors struct
//enum ColorType: String {
//    case main
//    case dark
//}
//extension ColorType {
//    var value: UIColor {
//        switch self {
//        case .main:
//            return #colorLiteral(red: 1, green: 0.6731276706, blue: 0.002335626882, alpha: 1)
//        case .dark:
//            return #colorLiteral(red: 0.8215842635, green: 0.5486085993, blue: 0.007432873241, alpha: 1)
//        }
//    }
//}
//
//
//
///// #2
//struct Colors {
//    /// will be stored in memory. one time init
//    /// will not be deinitialized from class which use it
//    /// but will be in memory to the app end
//    static let main = #colorLiteral(red: 1, green: 0.6731276706, blue: 0.002335626882, alpha: 1)
//    /// will NOT be stored in memory. init with every get
//    static var dark: UIColor {
//        return #colorLiteral(red: 0.8215842635, green: 0.5486085993, blue: 0.007432873241, alpha: 1)
//    }
//}
//extension Colors {
//    static func from(name: String) -> UIColor? {
//        switch name {
//        case "main":
//            return main
//        case "dark":
//            return dark
//        default:
//            return nil
//        }
//    }
//}
//
//
//
///// #3
//enum ColorType2: String {
//    case main
//    case dark
//}
//extension ColorType2 {
//    fileprivate static let Main = #colorLiteral(red: 1, green: 0.6731276706, blue: 0.002335626882, alpha: 1)
//    fileprivate static var Dark = #colorLiteral(red: 0.8215842635, green: 0.5486085993, blue: 0.007432873241, alpha: 1)
//}
//extension ColorType2 {
//    init?(color: UIColor) {
//        switch color {
//        case ColorType2.Main:
//            self = .main
//        case ColorType2.Dark:
//            self = .dark
//        default:
//            return nil
//        }
//    }
//}
//extension ColorType2 {
//    var value: UIColor {
//        switch self {
//        case .main:
//            return ColorType2.Main
//        case .dark:
//            return ColorType2.Dark
//        }
//    }
//}
//
///// #4
///// if you want one time init
//enum ColorType3: String {
//    case main
//    case dark
//}
//extension ColorType3 {
//    fileprivate static let Main = #colorLiteral(red: 1, green: 0.6731276706, blue: 0.002335626882, alpha: 1)
//    fileprivate static let Dark = #colorLiteral(red: 0.8215842635, green: 0.5486085993, blue: 0.007432873241, alpha: 1)
//}
//extension ColorType3 {
//    var value: UIColor {
//        switch self {
//        case .main:
//            return ColorType3.Main
//        case .dark:
//            return ColorType3.Dark
//        }
//    }
//}
//
///// #5
///// simplified func from(name: String). nothing to add is needed. only new colors
//final class Colors2: NSObject {
//    static let main = #colorLiteral(red: 1, green: 0.6731276706, blue: 0.002335626882, alpha: 1)
//    static let dark = #colorLiteral(red: 0.8215842635, green: 0.5486085993, blue: 0.007432873241, alpha: 1)
//}
//extension Colors2 {
//    static func from(name: String) -> UIColor? {
//        return value(forKey: name) as? UIColor
//    }
//}
