//
//  UICollectionView+Layout.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UICollectionView {
    func setLayout(itemSize: CGSize? = nil, verticalSpace: CGFloat? = nil, horisontalSpace: CGFloat? = nil) {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            if let itemSize = itemSize {
                layout.itemSize = itemSize
            }
            if let verticalSpace = verticalSpace {
                layout.minimumLineSpacing = verticalSpace
            }
            if let horisontalSpace = horisontalSpace {
                layout.minimumInteritemSpacing = horisontalSpace
            }
        }
    }
    
    @discardableResult
    func setCellWidthFor(columnsNumber: CGFloat, padding: CGFloat) -> CGSize {
        let viewWidth = bounds.width
        let itemWidth = floor((viewWidth - (columnsNumber - 1) * padding) / columnsNumber)
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
        }
        return itemSize
    }
}
