//
//  NoDelayScrollView.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 19/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

open class NoDelayScrollView: UIScrollView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        delaysContentTouches = false
    }
    
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}
