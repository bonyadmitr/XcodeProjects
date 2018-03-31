//
//  PhotoManagerDelegate.swift
//  LifeBox-new
//
//  Created by Bondar Yaroslav on 11/11/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Photos

protocol PhotoManagerDelegate: class {
    func photoLibraryDidChange(with changes: PHFetchResultChangeDetails<PHAsset>, fetchResult: PHFetchResult<PHAsset>?)
}

protocol PhotoManagerColectionViewDelegate: PhotoManagerDelegate {
    var collectionView: UICollectionView! { get }
}

extension PhotoManagerDelegate where Self: PhotoManagerColectionViewDelegate {
    
    func indexPaths(from indexSet: IndexSet?, section: Int) -> [IndexPath]? {
        guard let set = indexSet else {
            return nil
        }
        
        return set.map { (index) -> IndexPath in
            return IndexPath(item: index, section: section)
        }
    }

    
    func photoLibraryDidChange(with collectionChanges: PHFetchResultChangeDetails<PHAsset>, fetchResult: PHFetchResult<PHAsset>?) {

        if collectionChanges.hasIncrementalChanges {
            
            // If we have incremental diffs, animate them in the collection view.
            collectionView.performBatchUpdates({
                // For indexes to make sense, updates must be in this order:
                // delete, insert, reload, move
                if let removed = collectionChanges.removedIndexes, !removed.isEmpty {
                    collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                }
                if let inserted = collectionChanges.insertedIndexes, !inserted.isEmpty {
                    collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                }
                collectionChanges.enumerateMoves { fromIndex, toIndex in
                    print(fromIndex, toIndex)
                    self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                 to: IndexPath(item: toIndex, section: 0))
                }
            }, completion: { _ in
                self.collectionView.performBatchUpdates({
                    if let changed = collectionChanges.changedIndexes, !changed.isEmpty {
                        print(changed.map({ IndexPath(item: $0, section: 0) }))
                        print(changed)
                        self.collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                    }
                })
            })
            
        } else {
            //Reload the collection view if incremental diffs are not available.
            collectionView.reloadData()
        }
    }
}

