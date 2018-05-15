//
//  String+Substring.swift
//  OLPortal
//
//  Created by Lavrik Pavel on 20.03.17.
//  Copyright © 2017 sMediaLink. All rights reserved.
//

import Foundation

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
