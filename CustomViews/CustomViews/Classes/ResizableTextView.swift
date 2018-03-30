//
//  ResizableTextView.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 12.01.17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ResizableTextView: UITextView {
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: contentSize.height)
    }
}
