//
//  String+Size.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 08.09.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import UIKit

extension String {
    func getMinSizeWith(font: UIFont) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.size
    }
}
