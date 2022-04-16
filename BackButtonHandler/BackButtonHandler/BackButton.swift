//
//  BackButton.swift
//  BackButtonHandler
//
//  Created by Bondar Yaroslav on 09/04/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

typealias VoidHandler = () -> Void

/// loose the "swipe to go back". `navigationController?.interactivePopGestureRecognizer?.delegate = self` to fix it
/// not so good animation for button and nav bar title during pop
final class BackButtonItem: UIBarButtonItem {
    
    /// use `[weak self] in` for `action` to avoid memory leak
    convenience init(title: String? = nil, action: @escaping VoidHandler) {
        let button = BackButtonView(title: title, action: action)
        self.init(customView: button)
    }
    
//    convenience init(action: @escaping VoidHandler) {
//        let button = BackButton(action: action)
//        self.init(customView: button)
//    }
}





final class BackButton: UIButton {

    private var action: VoidHandler?

    /// text color is not gray during alert like arrow image (see example)
    var buttonColor: UIColor {
        get {
            return tintColor
        }
        set (color) {
            tintColor = color
            setTitleColor(color, for: .normal)
            setTitleColor(color.darker(by: 50), for: .highlighted) /// not like system back button
        }
    }

    convenience init(action: @escaping VoidHandler) {
        self.init(type: .custom)
        self.action = action
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        /// image can be resized to be like system arrow
//        let image = UIImage(named: "im_default_back_button") /// as template
//        let image = UIImage(named: "im_backButton") /// as template
//        let image = UIImage(named: "backIndicatorImage") /// as template
        let image = UIImage(named: "backArrow") /// as template


        let title = NSLocalizedString("Back", comment: "")

        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        buttonColor = UIColor.systemBlue
        
        imageEdgeInsets = UIEdgeInsets(top: -1, left: -15, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        
//        sizeToFit()
        
        addTarget(self, action: #selector(actionTouchUp), for: .touchUpInside)
    }
    
    @objc private func actionTouchUp() {
        action?()
    }
}
