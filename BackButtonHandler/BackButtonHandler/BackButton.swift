//
//  BackButton.swift
//  BackButtonHandler
//
//  Created by Bondar Yaroslav on 09/04/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

typealias VoidHandler = () -> Void

final class BackButtonItem: UIBarButtonItem {
    convenience init(action: @escaping VoidHandler) {
        let button = BackButton(action: action)
        self.init(customView: button)
    }
}

final class BackButton: UIButton {
    
    private var action: VoidHandler?
    
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
        let color = UIColor.black
        let image = UIImage(named: "im_backButton") /// as template
        let title = "Back"
        let font = UIFont.systemFont(ofSize: 17)
        let imageInset: CGFloat = -20
        let titleInset: CGFloat = -10
        
        titleLabel?.font = font
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        
        tintColor = color
        setTitleColor(color, for: .normal)
        setTitleColor(color.darker(by: 50), for: .highlighted)
        
        imageEdgeInsets = UIEdgeInsets(top: 2, left: imageInset, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 2, left: titleInset, bottom: 0, right: 0)
        
        sizeToFit()
        
        addTarget(self, action: #selector(actionTouchUp), for: .touchUpInside)
    }
    
    @objc func actionTouchUp() {
        action?()
    }
}
