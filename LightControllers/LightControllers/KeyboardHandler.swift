//
//  KeyboardHandler.swift
//  LightControllers
//
//  Created by Bondar Yaroslav on 26/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol KeyboardHandler {}
extension KeyboardHandler where Self: UIViewController {
    
    func addKeyboardController() {
        let vc = KeyboardViewController(view: view)
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
    
    func addKeyboardController(with scrollView: UIScrollView) {
        let vc = KeyboardScrollController(scrollView: scrollView)
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
}

extension UIView: KeyboardHandler {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(window?.endEditing))
        addGestureRecognizer(tapGesture)
    }
}
//extension KeyboardHandler where Self: UIView {
//
//}
