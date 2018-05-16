//
//  UITextField+Cursor.swift
//  SwiftBest
//
//  Created by zdaecqze zdaecq on 26.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

//TODO: Need create more functions
extension UITextField {
    func setCursor(position pos: Int) {
        if let newPosition = positionFromPosition(beginningOfDocument, inDirection: .Right, offset: pos) {
            selectedTextRange = textRangeFromPosition(newPosition, toPosition: newPosition)
        }
    }
}
