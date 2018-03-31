//
//  SelectingView.swift
//  SegmentedColControl
//
//  Created by Bondar Yaroslav on 28/03/2017.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import UIKit

final class SelectingView: UIView {
    
    var selectingAnimationType = SelectiongAnimation.spring
    var animationTime: TimeInterval = 0.3
    
    var selectingViewSize = SelectingViewSize.inset(dx: 10, dy: 0)
    
    func setSize(for rect: CGRect) {
        switch selectingViewSize {
        case .inset(dx: let dx, dy: let dy):
            frame = rect.insetBy(dx: dx, dy: dy)
        case .custom(let size):
            frame.size = size
        }
    }
    
    func animate(for rect: CGRect) {
        var duration: TimeInterval!
        var spring: CGFloat!
        
        switch selectingAnimationType {
        case .none:
            duration = 0
            spring = 1
        case .basic:
            duration = animationTime
            spring = 1
        case .spring:
            duration = animationTime
            spring = 0.7
        }
        
        UIView.animate(
            withDuration: duration, delay: 0,
            usingSpringWithDamping: spring,
            initialSpringVelocity: 0,
            options: [.curveEaseInOut], animations: {
                self.setSize(for: rect)
        }, completion: nil)
    }
}
