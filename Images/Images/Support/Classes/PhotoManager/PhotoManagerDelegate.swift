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
            
           
            /// https://stackoverflow.com/questions/29337765/crash-attempt-to-delete-and-reload-the-same-index-path/30942726
            // Get the changes as lists of index paths for updating the UI.
//            var removedPaths: [IndexPath]?
//            var insertedPaths: [IndexPath]?
//            var changedPaths: [IndexPath]?
//            if let removed = collectionChanges.removedIndexes {
//                removedPaths = self.indexPaths(from: removed, section: 0)
//            }
//            if let inserted = collectionChanges.insertedIndexes {
//                insertedPaths = self.indexPaths(from:inserted, section: 0)
//            }
//            if let changed = collectionChanges.changedIndexes {
//                changedPaths = self.indexPaths(from: changed, section: 0)
//            }
//            var shouldReload = false
//            if let removedPaths = removedPaths, let changedPaths = changedPaths {
//                for changedPath in changedPaths {
//                    if removedPaths.contains(changedPath) {
//                        shouldReload = true
//                        break
//                    }
//                }
//            }
//
//            if let item = removedPaths?.last?.item {
//                if item >= fetchResult.count {
//                    shouldReload = true
//                }
//            }
//
//            if shouldReload {
//                collectionView.reloadData()
//            } else {
//                // Tell the collection view to animate insertions/deletions/moves
//                // and to refresh any cells that have changed content.
//                collectionView.performBatchUpdates({
//                    if let theRemovedPaths = removedPaths {
//                        collectionView.deleteItems(at: theRemovedPaths)
//                    }
//                    if let theInsertedPaths = insertedPaths {
//                        collectionView.insertItems(at: theInsertedPaths)
//                    }
//                    if let theChangedPaths = changedPaths {
//                        collectionView.reloadItems(at: theChangedPaths)
//                    }
//
//                    collectionChanges.enumerateMoves { fromIndex, toIndex in
//                        self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
//                                                     to: IndexPath(item: toIndex, section: 0))
//                    }
//                })
//            }

            
            
            
            
            
            
            
            
            
            
            
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
                if let changed = collectionChanges.changedIndexes, !changed.isEmpty {
                    print(changed.map({ IndexPath(item: $0, section: 0) }))
                    print(changed)
                    collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                }
                
            })
            
            
            
//            collectionView.performBatchUpdates({
//                // For indexes to make sense, updates must be in this order:
//                // delete, insert, reload, move
//                if let removed = collectionChanges.removedIndexes, !removed.isEmpty {
//                    collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
//                }
//                if let inserted = collectionChanges.insertedIndexes, !inserted.isEmpty {
//                    collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
//                }
//                if let changed = collectionChanges.changedIndexes, !changed.isEmpty {
//                    self.collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
//                }
//            }, completion: { _ in
//
//                collectionChanges.enumerateMoves { fromIndex, toIndex in
//                    guard fromIndex != toIndex else {
//                        return
//                    }
//                    self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
//                                                 to: IndexPath(item: toIndex, section: 0))
//                }
//            })
        } else {
            //Reload the collection view if incremental diffs are not available.
            collectionView.reloadData()
        }
    }
}

