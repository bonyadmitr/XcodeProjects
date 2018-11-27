//
//  Text+Size.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// http://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift

extension String {
    func height(forWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}

extension NSAttributedString {
    func height(forWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func width(forHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}
