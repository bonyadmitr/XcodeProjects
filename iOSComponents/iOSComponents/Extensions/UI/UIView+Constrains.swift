//
//  UIView+Constrains.swift
//  GenericTableViewController
//
//  Created by Bondar Yaroslav on 22.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

public extension UIView {
    
    public func constrainEdges(toMarginOf view: UIView) {
        
        if #available(iOS 9.0, *) {
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        } else {
            constrainEqual(.top, to: view, .top)
            constrainEqual(.leading, to: view, .leading)
            constrainEqual(.trailing, to: view, .trailing)
            constrainEqual(.bottom, to: view, .bottom)
        }
    }
    
    public func constrainEqual(_ attribute: NSLayoutAttribute, to: AnyObject,
                               _ toAttribute: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal,
                           toItem: to, attribute: toAttribute, multiplier: multiplier, constant: constant).isActive = true
    }
}
