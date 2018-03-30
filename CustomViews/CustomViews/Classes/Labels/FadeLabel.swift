//
//  FadeLabel.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 16.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

open class FadeLabel: UILabel {   
    open override var text: String? {
        didSet {
            UIView.transition(with: self, duration: 0.3,
                              options: [.curveEaseInOut, .transitionCrossDissolve],
                              animations: nil, completion: nil)
        }
    }
}
