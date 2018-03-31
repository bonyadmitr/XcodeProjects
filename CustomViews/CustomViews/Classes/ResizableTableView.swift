//
//  ResizableTableView.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 3/25/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ResizableTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
