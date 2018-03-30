//
//  StickyHeaderTableView.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 19/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final public class StickyHeaderTableView: UITableView {
    
    public var headerView: UIView!
    public var headerMaxHeight: CGFloat = 200
    public var headerMinHeight: CGFloat = 100
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        headerView = tableHeaderView
        headerView.clipsToBounds = true
        headerMaxHeight = headerView.bounds.height
        tableHeaderView = nil
        addSubview(headerView)
        
        contentInset = UIEdgeInsets(top: headerMaxHeight, left: 0, bottom: 0, right: 0)
        contentOffset = CGPoint(x: 0, y: -headerMaxHeight)
    }
    
    public func updateHeaderView() {
        let didScrollPastMinHeaderHeight = contentOffset.y < -headerMinHeight
        let headerHeight = didScrollPastMinHeaderHeight ? -contentOffset.y : headerMinHeight
        headerView.frame = CGRect(x: 0, y: contentOffset.y, width: bounds.width, height: headerHeight)
    }
}
