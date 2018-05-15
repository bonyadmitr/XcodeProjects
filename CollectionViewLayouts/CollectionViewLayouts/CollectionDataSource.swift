//
//  CollectionDataSource.swift
//  CollectionViewLayouts
//
//  Created by Bondar Yaroslav on 18.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

public class CollectionDataSource: NSObject {
    
    var categories: [String]
    
    init(categories: [String]) {
        self.categories = categories
    }
}

//MARK: - UICollectionViewDataSource

extension CollectionDataSource: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OCCategoryColCell", for: indexPath)
//        if Language.system == .Hebrew {
//            cell.transform = CGAffineTransformMakeScale(-1, 1)
//        }
//        cell.nameLabel.text = categories[indexPath.row].name
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension CollectionDataSource: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSizeFor(indexPath: indexPath)
    }
    
    // MARK: Helpers
    
    func getCellSizeFor(indexPath: IndexPath) -> CGSize {
        let font = UIFont.systemFont(ofSize: 10)
        let categoryName = categories[indexPath.row]
        let minSize = categoryName.getMinSizeWith(font: font)
        return CGSize(width: minSize.width + 10, height: 20)
    }
}
