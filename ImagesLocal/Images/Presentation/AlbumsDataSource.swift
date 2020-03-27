import UIKit
import Photos

struct FetchedAlbum {
    let assetCollection: PHAssetCollection
    var fetchResult: PHFetchResult<PHAsset>
}

final class AlbumsDataSource: NSObject {
    
    enum FetchType {
        case image
        case video
        case all
        
        var predicate: NSPredicate? {
            switch self {
            case .image:
                return fetchMediaTypePredicate(mediaType: .image)
            case .video:
                return fetchMediaTypePredicate(mediaType: .video)
            case .all:
                return nil
                //return fetchPhotosVideosPredicate()
            }
        }
        
        private func fetchMediaTypePredicate(mediaType: PHAssetMediaType) -> NSPredicate {
            return NSPredicate(format: "\(#keyPath(PHAsset.mediaType)) == %d", mediaType.rawValue)
        }

        //private func fetchPhotosVideosPredicate() -> NSPredicate {
        //    let fetchKey = #keyPath(PHAsset.mediaType)
        //    return NSPredicate(format: "\(fetchKey) == %d || \(fetchKey) == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        //}
    }
    
    enum FetchOption {
        case all
        case notEmpty
    }
    
    private var fetchType = FetchType.all
    private var fetchOption = FetchOption.notEmpty
    
    var tableView: UITableView!
    
    func chechFetch(type: FetchType, options: FetchOption) {
        fetchType = type
        fetchOption = options
        fetchAll()
    }
    
    var smartAlbums = [FetchedAlbum]()
    var userAlbums = [FetchedAlbum]()
    
    var allPhotos: PHFetchResult<PHAsset>!
    private var smartAlbumsFetchResult: PHFetchResult<PHAssetCollection>!
    private var userAlbumsFetchResult: PHFetchResult<PHAssetCollection>!
    
    override init() {
        super.init()
        fetchAll()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func fetchAll() {
        fetchAlbums()
        updateSmartAlbumsFetchAssets()
        updateUserAlbumsFetchAssets()
    }
    
    private func fetchAlbums() {
        let allPhotosOptions = PHAsset.creationDateFetchOptions(predicate: fetchType.predicate)
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        smartAlbumsFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        let userAlbumsFetchOptions = PHFetchOptions()
        userAlbumsFetchOptions.sortDescriptors = [NSSortDescriptor(key: #keyPath(PHAssetCollection.localizedTitle), ascending: true)]
        
        if fetchOption == .notEmpty {
            /// predicate with estimatedAssetCount not working for .smartAlbum
            userAlbumsFetchOptions.predicate = NSPredicate(format: "\(#keyPath(PHAssetCollection.estimatedAssetCount)) > 0")
        }
        
        userAlbumsFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: userAlbumsFetchOptions)
        
        /// to fetch Folders as PHCollectionList
        //PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }
    
    private func updateSmartAlbumsFetchAssets() {
        smartAlbums.removeAll()
        
        smartAlbumsFetchResult.enumerateObjects { [weak self] collection, _, _ in
            guard let self = self else { return }
            let fetchAssets = collection.fetchAssets(predicate: self.fetchType.predicate)
            
            if self.canBeAdded(fetchAssets: fetchAssets) {
                let fetchedAlbum = FetchedAlbum(assetCollection: collection, fetchResult: fetchAssets)
                self.smartAlbums.append(fetchedAlbum)
            }
        }
    }
    
    private func updateUserAlbumsFetchAssets() {
        userAlbums.removeAll()
        
        userAlbumsFetchResult.enumerateObjects { [weak self] collection, _, _ in
            guard let self = self else { return }
            let fetchAssets = collection.fetchAssets(predicate: self.fetchType.predicate)
            
            if self.canBeAdded(fetchAssets: fetchAssets) {
                let fetchedAlbum = FetchedAlbum(assetCollection: collection, fetchResult: fetchAssets)
                self.userAlbums.append(fetchedAlbum)
            }
        }
    }
    
        
    private func canBeAdded(fetchAssets: PHFetchResult<PHAsset>) -> Bool {
        return fetchOption == .all || fetchAssets.count > 0
        
//        switch fetchOption {
//        case .all:
//            return true
//        case .notEmpty:
//            if fetchAssets.count > 0 {
//                return true
//            } else {
//                return false
//            }
//        }
    }
}

extension AlbumsDataSource: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            /// Check each of the three top-level fetches for changes.
            
            /// allPhotos
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
            }
            
            /// smartAlbums seems like don't have changes and changeInstance.changeDetails(for: smartAlbums) == nil so refetch all
            smartAlbumsFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            updateSmartAlbumsFetchAssets()
            
            /// userCollections
            if let changeDetails = changeInstance.changeDetails(for: userAlbumsFetchResult) {
                userAlbumsFetchResult = changeDetails.fetchResultAfterChanges
                updateUserAlbumsFetchAssets()
            }
            
            /// can be used reloadSections for animation
            ///tableView.reloadSections(IndexSet(integer: Section.allPhotos.rawValue), with: .automatic)
            tableView.reloadData()
        }
        
    }
    
    
}
