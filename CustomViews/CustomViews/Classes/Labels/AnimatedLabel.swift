//
//  AnimatedLabel.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 16.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

open class AnimatedLabel: UILabel {
    open override var text: String? {
        didSet {
            let animation = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = kCATransitionPush
            animation.subtype = kCATransitionFromTop
            animation.duration = 0.3
            layer.add(animation, forKey: kCATransitionPush)
        }
    }
}
