import Photos

extension PHAssetCollection {
    
    func fetchAssets(predicate: NSPredicate?) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHAsset.creationDateFetchOptions(predicate: predicate)
        return PHAsset.fetchAssets(in: self, options: fetchOptions)
    }
}

extension PHAsset {
    
    static func creationDateFetchOptions(predicate: NSPredicate?) -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = predicate
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: #keyPath(PHAsset.creationDate), ascending: false)]
        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeiTunesSynced, .typeCloudShared]
        return fetchOptions
    }
}


//extension PHAssetCollection {
//
//    var itemsCount: Int {
//        /// source https://stackoverflow.com/a/47565215/5893286
//        /// wors only with user albums, not with smart ones
//        let estimatedCount = estimatedAssetCount
//        if estimatedCount != NSNotFound {
//            return estimatedCount
//        }
//
//        let fetchOptions = PHFetchOptions()
//        //fetchOptions.predicate = NSPredicate(format: "\(#keyPath(PHAsset.mediaType)) == %d", PHAssetMediaType.image.rawValue)
//        let result = PHAsset.fetchAssets(in: self, options: fetchOptions)
//        return result.count
//    }
//
//    static func fetchSmartAlbums(with types: [PHAssetCollectionSubtype]) -> [PHAssetCollection] {
//        let options = PHFetchOptions()
//        options.fetchLimit = 1
//
//        return types.compactMap {
//            fetchAssetCollections(with: .smartAlbum, subtype: $0, options: options).firstObject
//        }
//    }
//
//    static func fetchUserAlbums(with options: PHFetchOptions? = nil) -> PHFetchResult<PHAssetCollection> {
//        fetchAssetCollections(with: .album, subtype: .albumRegular, options: options)
//    }
//
//    func updated() -> PHAssetCollection {
//        return PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [localIdentifier], options: nil).firstObject ?? self
//    }
//
//}
