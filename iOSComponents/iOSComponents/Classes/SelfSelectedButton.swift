//
//  SelfSelectedButton.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 05/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// use text color for state instead tint color
/// bcz tint color affect to selected background color
class SelfSelectedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// required UIColor+Default or #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) for defaultBlue
    private func setup() {
        addTarget(self, action: #selector(setSelected), for: .touchUpInside)
        tintColor = UIColor.clear
        setTitleColor(UIColor.defaultBlue, for: .normal)
        setTitleColor(UIColor.defaultBlue, for: .selected)
        setTitleColor(UIColor.lightGray, for: .disabled)
    }
    
    @objc private func setSelected() {
        isSelected = !isSelected
    }
}
