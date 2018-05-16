//
//  UILabelExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import UIKit

extension UILabel {

    /// EZSwiftExtensions
    public func setText(text: String?, animated: Bool, duration: NSTimeInterval = 0.3) {
        if animated {
            UIView.transitionWithView(self, duration: duration, options: .TransitionCrossDissolve, animations: { () -> Void in
                self.text = text
                }, completion: nil)
        } else {
            self.text = text
        }
    }
}
