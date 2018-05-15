//
//  ColumnsCollectionLayout.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 18.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: landscape layout

final class ColumnsCollectionLayout: UICollectionViewFlowLayout {
    
    @IBInspectable var numberOfColumns: Int = 2
    @IBInspectable var cellHeight: CGFloat = 100
    
//    override public init() {
//        super.init()
//        setup()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
    
//    public override func awakeFromNib() {
//        super.awakeFromNib()
//        setup()
//    }
//
//    private func setup() {
//        //        minimumLineSpacing = 5
//        //        minimumInteritemSpacing = 5
//        //        sectionInset = .zero
//
//        let size = width(for: numberOfColumns)
//        itemSize = CGSize(width: size, height: cellHeight)
//    }
//
//    private func width(for numberOfColumns: Int) -> CGFloat {
//        let emptySpace = sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(numberOfColumns - 1)
//        collectionView!.layoutIfNeeded()
//        return (collectionView!.bounds.width - emptySpace) / CGFloat(numberOfColumns)
//    }
    
    

    override var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else {
                return super.itemSize
            }
            let marginsAndInsets = sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(numberOfColumns - 1)
            collectionView.setNeedsLayout()
            let itemWidth = ((collectionView.bounds.width - marginsAndInsets) / CGFloat(numberOfColumns)).rounded(.down)
            return CGSize(width: itemWidth, height: itemWidth)
        }
        set {
            super.itemSize = newValue
        }
    }
    
//    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
//        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
//        context.invalidateFlowLayoutDelegateMetrics = newBounds != collectionView?.bounds
//        return context
//    }
}
