//
//  MenuPanGesture.swift
//  MenuDouble3
//
//  Created by Yaroslav Bondar on 16.03.17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class MenuPanGesture: UIPanGestureRecognizer {
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        setup()
    }
    
    func setup() {
        delegate = self
    }
}

extension MenuPanGesture: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        guard
//            let gesture = otherGestureRecognizer as? UIPanGestureRecognizer,
//            let gestureView = gesture.view,
//            let vc = gestureView.parentViewController,
//            let menuVC = vc.menuDoubleController,
//            vc.classForCoder != menuVC.leftVC.classForCoder,
//            vc.classForCoder != menuVC.rightVC.classForCoder
//            else { return false }
//        
//        let velocity = gesture.velocity(in: gestureView)
//        if velocity.x < 0 {
//            return true
//        }
        return false
    }
}
