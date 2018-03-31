//
//  PhotoCell.swift
//  Images
//
//  Created by Bondar Yaroslav on 28/01/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var representedAssetIdentifier = ""
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

extension PhotoManager {
    func fill(cell: PhotoCell, for indexPath: IndexPath) {
        guard let asset = fetchResult?.object(at: indexPath.item) else {
            return
        }
        cell.representedAssetIdentifier = asset.localIdentifier
        
        cachingManager.requestImage(for: asset, targetSize: photoSize, contentMode: .default, options: requestOptions, resultHandler: { image, _ in
            /// The cell may have been recycled by the time this handler gets called;
            /// set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier, image != nil {
                cell.imageView.image = image
            }
        })
    }
}

// TODO: reuse without UIScreen + class
@discardableResult
func saveAndGetItemSize(for collectionView: UICollectionView) -> CGSize {
    
    let viewWidth = UIScreen.main.bounds.width
    
    let desiredItemWidth: CGFloat = 100
    let columns: CGFloat = max(floor(viewWidth / desiredItemWidth), 4)
    let padding: CGFloat = 1
    let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
    let itemSize = CGSize(width: itemWidth, height: itemWidth)
    
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
    }
    return itemSize
}

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
