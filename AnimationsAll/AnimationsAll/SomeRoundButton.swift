//
//  SomeRoundButton.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 27.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class SomeRoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 5
    }
}
