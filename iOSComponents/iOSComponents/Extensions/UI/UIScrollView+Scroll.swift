//
//  UIScrollView+Scroll.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 15.08.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func scrollToTop() {
        setContentOffset(CGPoint(), animated: true)
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: true)
    }
}
