//
//  Text+Size.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// http://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift
/// label way: https://stackoverflow.com/a/39426425/5893286

extension String {
    func height(for width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        return boundingBox.height
    }
}

extension NSAttributedString {
    func height(for width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func width(for height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}
