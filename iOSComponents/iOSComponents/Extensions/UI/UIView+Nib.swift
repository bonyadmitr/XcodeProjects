//
//  UIView+Nib.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 31.01.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import UIKit

extension UIView {
    
    func setupFromNib() {
        let view = loadFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func loadFromNib() -> UIView {
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
