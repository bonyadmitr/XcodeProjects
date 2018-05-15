//
//  Colors+Views.swift
//  Customization
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

private let colorError = "there is no color type:"

extension UIView {
    fileprivate func colorErrorMessage(for value: Any) -> String {
        return  "⚠️ \(colorError) \(value) in: \(self.classForCoder) ⚠️"
    }
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder")
    @IBInspectable public var czBackColor: String {
        get { return "" }
        set {
            guard let color = Colors.from(name: newValue) else {
                return print(colorErrorMessage(for: newValue))
            }
            backgroundColor = color
        }
    }
    @available(*, unavailable, message: "This property is reserved for Interface Builder")
    @IBInspectable public var czTintColor: String {
        get { return "" }
        set {
            guard let color = Colors.from(name: newValue) else {
                return print(colorErrorMessage(for: newValue))
            }
            tintColor = color
        }
    }
}

extension UILabel {
    @available(*, unavailable, message: "This property is reserved for Interface Builder")
    @IBInspectable public var czTextColor: String {
        get { return "" }
        set {
            guard let color = Colors.from(name: newValue) else {
                return print(colorErrorMessage(for: newValue))
            }
            textColor = color
        }
    }
}

extension UIButton {
    @available(*, unavailable, message: "This property is reserved for Interface Builder")
    @IBInspectable public var czTextColor: String {
        get { return "" }
        set {
            guard let color = Colors.from(name: newValue) else {
                return print(colorErrorMessage(for: newValue))
            }
            titleColorAllStates = color
        }
    }
    public var titleColorAllStates: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
            setTitleColor(newValue, for: .highlighted)
            setTitleColor(newValue, for: .disabled)
            setTitleColor(newValue, for: .selected)
            setTitleColor(newValue, for: .focused)
            setTitleColor(newValue, for: .application)
            setTitleColor(newValue, for: .reserved)
        }
    }
}
extension UITextField {
    @available(*, unavailable, message: "This property is reserved for Interface Builder")
    @IBInspectable public var czTextColor: String {
        get { return "" }
        set {
            guard let color = Colors.from(name: newValue) else {
                return print(colorErrorMessage(for: newValue))
            }
            textColor = color
        }
    }
}

extension UITextView {
    @available(*, unavailable, message: "This property is reserved for Interface Builder")
    @IBInspectable public var czTextColor: String {
        get { return "" }
        set {
            guard let color = Colors.from(name: newValue) else {
                return print(colorErrorMessage(for: newValue))
            }
            textColor = color
        }
    }
}
