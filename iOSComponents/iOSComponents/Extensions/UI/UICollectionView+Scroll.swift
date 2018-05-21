//
//  UICollectionView+Scroll.swift
//  CollectionViewLayouts
//
//  Created by Bondar Yaroslav on 13.01.17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    public func scrollToBottom(animated: Bool) {
        let numberOfRows = numberOfItems(inSection: 0)
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
            scrollToItem(at: indexPath, at: .bottom, animated: animated)
        }
    }
}
