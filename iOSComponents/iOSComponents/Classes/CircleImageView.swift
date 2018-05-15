//
//  CircleImageView.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 02/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    override var bounds: CGRect {
        willSet {
            layer.cornerRadius = newValue.width / 2
        }
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
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
}
