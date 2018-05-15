//
//  UIColor+Default.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 05/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIColor {
    /// why @nonobjc needs:
    /// http://stackoverflow.com/questions/29814706/a-declaration-cannot-be-both-final-and-dynamic-error-in-swift-1-2
    @nonobjc static var defaultBlue: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    @nonobjc static var defaultNavBar: UIColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
}
