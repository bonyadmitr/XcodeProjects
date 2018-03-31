//
//  ColumnsCollectionLayout.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 18.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: landscape layout

final public class ColumnsCollectionLayout: UICollectionViewFlowLayout {
    
    @IBInspectable var cellsPerRow: Int = 2
    @IBInspectable var cellHeight: CGFloat = 100
    
    override public var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else { return super.itemSize }
            let marginsAndInsets
                = sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            let itemWidth = (collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)
            return CGSize(width: itemWidth, height: cellHeight)
        }
        set {
            super.itemSize = newValue
        }
    }
}
