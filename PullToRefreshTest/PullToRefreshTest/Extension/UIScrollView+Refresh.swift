//
//  UIScrollView+Refresh.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 15/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    typealias RefreshBlock = (_ refreshControl: UIRefreshControl) -> Void
    private static let refreshAssociation = AssociationManager<RefreshBlock>()
    
    var refreshBlock: RefreshBlock? {
        get { return UIScrollView.refreshAssociation[self] }
        set { UIScrollView.refreshAssociation[self] = newValue }
    }
    
    func addRefreshControl(title: String? = nil, color: UIColor? = nil, refreshHandler: RefreshBlock? = nil) {
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        if let handler = refreshHandler {
            refreshBlock = handler
        }
        
        if let title = title {
            if let color = color {
                let attr = [NSForegroundColorAttributeName: color]
                refresher.attributedTitle = NSAttributedString(string: title, attributes: attr)
                refresher.tintColor = color
            } else {
                refresher.attributedTitle = NSAttributedString(string: title)
            }
            
        } else if let color = color {
            refresher.tintColor = color
        }
        
        if #available(iOS 10.0, *) {
            refreshControl = refresher
        } else {
            insertSubview(refresher, at: 0)
            /// http://stackoverflow.com/questions/15233147/header-displaced-in-tableview-with-uirefreshcontrol
            /// http://stackoverflow.com/questions/12497940/uirefreshcontrol-without-uitableviewcontroller
            /// or self.addChildViewController(self.tableViewController)
        }
    }
    
    @objc private func refreshData(_ refreshControl: UIRefreshControl) {
        refreshBlock?(refreshControl)
    }
}
