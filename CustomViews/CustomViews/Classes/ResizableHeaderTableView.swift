//
//  ResizableHeaderTableView.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 16.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

open class ResizableHeaderTableView: UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        sizeHeaderToFit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sizeHeaderToFit()
    }
    
    private func sizeHeaderToFit() {
        guard let header = tableHeaderView else { return }
        let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        header.frame.size.height = height
        tableHeaderView = header
    }
}
