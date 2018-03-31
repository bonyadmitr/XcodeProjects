//
//  PhotoManager.swift
//  LifeBox-new
//
//  Created by Bondar Yaroslav on 11/11/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Photos

final class PhotoManager: NSObject {
    
    // MARK: - Main
    
    var photoSize = PHImageManagerMaximumSize
    var fetchResult: PHFetchResult<PHAsset>?
    
    weak var delegate: PhotoManagerDelegate?
    
    private var previousPreheatRect = CGRect.zero
    
    private lazy var photoLibrary = PHPhotoLibrary.shared()
    
    internal lazy var cachingManager: PHCachingImageManager = {
        let cachingManager = PHCachingImageManager()
        cachingManager.allowsCachingHighQualityImages = false
        return cachingManager
    }()
    
    lazy var requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        return options
    }()
    
    func prepereForUse() {
        photoLibrary.register(self)
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "isFavorite", ascending: true)]
        //allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
    }
    
    deinit {
        photoLibrary.unregisterChangeObserver(self)
    }
}

// MARK: - Asset Caching
extension PhotoManager {
    
    func updateCachedAssetsFor(collectionView: UICollectionView) {
        // Update only if the view is visible.
        guard let view = collectionView.superview, view.window != nil else { return }
        
        // The preheat window is twice the height of the visible rect.
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
            .flatMap { indexPath in fetchResult?.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
            .flatMap { indexPath in fetchResult?.object(at: indexPath.item) }
        
        // Update the assets the PHCachingImageManager is caching.
        cachingManager.startCachingImages(for: addedAssets,
                                          targetSize: photoSize, contentMode: .aspectFill, options: nil)
        cachingManager.stopCachingImages(for: removedAssets,
                                         targetSize: photoSize, contentMode: .aspectFill, options: nil)
        
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
    
    private func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
    
    func resetCachedAssets() {
        cachingManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
}

extension PhotoManager: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print(changeInstance)
        
        guard
            let fetchResult = fetchResult,
            let changes = changeInstance.changeDetails(for: fetchResult)
        else {
            return
        }
        
        /// Change notifications may be made on a background queue. Re-dispatch to the
        /// main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            self.fetchResult = changes.fetchResultAfterChanges
            self.delegate?.photoLibraryDidChange(with: changes, fetchResult: self.fetchResult)
            resetCachedAssets()
        }
    }
}

// MARK: - UICollectionView+IndexPath

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}
