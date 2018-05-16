//
//  Fonts+Views.swift
//  Customization
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit


fileprivate let fontErrorMessage = "- there is no font type:"

extension UIView {
    fileprivate func fontErrorMessage(for value: Any) -> String {
        return  "\(fontErrorMessage) \(value) in: \(self.classForCoder)"
    }
}

extension UILabel {
    @available(*, unavailable, message: "This property is reserved for Interface Builder")
    @IBInspectable public var fontType: String {
        get { return "" }
        set {
            guard let type = Fonts(rawValue: newValue) else {
                return print(fontErrorMessage(for: newValue))
            }
            font = type.font(with: font.pointSize)
        }
    }
}

extension UIButton {
    @available(*, unavailable, message: "This property is reserved for Interface Builder")
    @IBInspectable public var fontType: String {
        get { return "" }
        set {
            guard let type = Fonts(rawValue: newValue) else {
                return print(fontErrorMessage(for: newValue))
            }
            titleLabel!.font = type.font(with: titleLabel!.font.pointSize)
        }
    }
}

extension UITextField {
    @available(*, unavailable, message: "This property is reserved for Interface Builder")
    @IBInspectable public var fontType: String {
        get { return "" }
        set {
            guard let type = Fonts(rawValue: newValue) else {
                return print(fontErrorMessage(for: newValue))
            }
            font = type.font(with: font!.pointSize)
        }
    }
}

extension UITextView {
    @available(*, unavailable, message: "This property is reserved for Interface Builder")
    @IBInspectable public var fontType: String {
        get { return "" }
        set {
            guard let type = Fonts(rawValue: newValue) else {
                return print(fontErrorMessage(for: newValue))
            }
            font = type.font(with: font!.pointSize)
        }
    }
}
