//
//  UIView+Parent.swift
//  MenuDouble3
//
//  Created by Yaroslav Bondar on 16.03.17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
