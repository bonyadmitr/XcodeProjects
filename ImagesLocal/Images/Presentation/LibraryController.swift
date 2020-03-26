//
//  LibraryController.swift
//  Images
//
//  Created by Bondar Yaroslav on 11/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Photos

enum Section: Int {
    case allPhotos = 0
    case smartAlbums
    case userCollections
    
    static let count = 3
}

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
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: #keyPath(PHAsset.creationDate), ascending: true)]
        allPhotosOptions.predicate = fetchType.predicate
        allPhotosOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeiTunesSynced, .typeCloudShared]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        smartAlbumsFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        let userAlbumFetchOptions = PHFetchOptions()
        userAlbumFetchOptions.sortDescriptors = [NSSortDescriptor(key: #keyPath(PHAssetCollection.localizedTitle), ascending: true)]
        
        /// use switch to eazy handle to cases
        switch fetchOption {
        case .all: break
        case .notEmpty:
            /// predicate with estimatedAssetCount not working for .smartAlbum
            userAlbumFetchOptions.predicate = NSPredicate(format: "\(#keyPath(PHAssetCollection.estimatedAssetCount)) > 0")
        }
        
        userAlbumsFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: userAlbumFetchOptions)
        
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
//                tableView.reloadSections(IndexSet(integer: Section.allPhotos.rawValue), with: .automatic)
            }
            
            /// smartAlbums seems like don't have changes and changeInstance.changeDetails(for: smartAlbums) == nil so refetch all
            smartAlbumsFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            updateSmartAlbumsFetchAssets()
//            tableView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue), with: .automatic)
            
            /// userCollections
            if let changeDetails = changeInstance.changeDetails(for: userAlbumsFetchResult) {
                userAlbumsFetchResult = changeDetails.fetchResultAfterChanges
                updateUserAlbumsFetchAssets()
//                tableView.reloadSections(IndexSet(integer: Section.userCollections.rawValue), with: .automatic)
            }
            
            tableView.reloadData()
        }
        
    }
    
    
}

final class AlbumsController: UIViewController {
    
    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    
    let albumsDataSource = AlbumsDataSource()
    
    private let cellId = String(describing: DetailTableViewCell.self)
    
    private lazy var tableView: UITableView = {
        let newValue: UITableView
        if #available(iOS 13.0, *) {
            newValue = UITableView(frame: view.bounds, style: .insetGrouped)
        } else {
            //newValue = UITableView(frame: view.bounds, style: .plain)
            newValue = UITableView(frame: view.bounds, style: .grouped)
        }
        
        newValue.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        newValue.dataSource = self
        newValue.delegate = self
        //        let nib = UINib(nibName: cellId, bundle: nil)
        //        newValue.register(nib, forCellReuseIdentifier: cellId)
        newValue.register(DetailTableViewCell.self, forCellReuseIdentifier: cellId)
        return newValue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumsDataSource.tableView = tableView
        view.addSubview(tableView)
    }
    
}


extension AlbumsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .allPhotos: return 1
        case .smartAlbums: return albumsDataSource.smartAlbums.count
        case .userCollections: return albumsDataSource.userAlbums.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(reusable: DetailTableViewCell.self, for: indexPath)
    }
}

extension AlbumsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionLocalizedTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            cell.textLabel?.text = NSLocalizedString("All Photos", comment: "")
            cell.detailTextLabel?.text = String(albumsDataSource.allPhotos.count)
        case .smartAlbums:
            let album = albumsDataSource.smartAlbums[indexPath.row]
            cell.textLabel?.text = album.assetCollection.localizedTitle
            cell.detailTextLabel?.text = String(album.fetchResult.count)
        case .userCollections:
            let album = albumsDataSource.userAlbums[indexPath.row]
            cell.textLabel?.text = album.assetCollection.localizedTitle
            cell.detailTextLabel?.text = String(album.fetchResult.count)
//            let collection = albumsDataSource.userAlbums.object(at: indexPath.row)
//            cell.textLabel?.text = collection.localizedTitle
//            cell.detailTextLabel?.text = String(albumsDataSource.userAlbumsFetchAssets[indexPath.row].count)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}


final class DetailTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}








final class LibraryController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Types for managing sections, cell and segue identifiers
    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections
        
        static let count = 3
    }
    
//    enum SegueIdentifier: String {
//        case showAllPhotos
//        case showCollection
//    }
    
    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>! {
        didSet {
            smartAlbumsFetchAssets.removeAll()
            
            smartAlbums.enumerateObjects { [weak self] collection, _, _ in
                guard let `self` = self else { return }
                let fetchAssets = collection.fetchAssets(of: .image)
                self.smartAlbumsFetchAssets.append(fetchAssets)
            }
        }
    }
    
    var userCollections: PHFetchResult<PHAssetCollection>!
    var smartAlbumsFetchAssets: [PHFetchResult<PHAsset>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: #keyPath(PHAsset.creationDate), ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        let smartAlbumFetchOptions = PHFetchOptions()
        /// not working https://stackoverflow.com/a/46665140/5893286
        ///smartAlbumFetchOptions.predicate = NSPredicate(format: "\(#keyPath(PHAssetCollection.estimatedAssetCount)) > 0")
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: smartAlbumFetchOptions)
        
        let userAlbumFetchOptions = PHFetchOptions()
        userAlbumFetchOptions.sortDescriptors = [NSSortDescriptor(key: #keyPath(PHAssetCollection.localizedTitle), ascending: true)]
        userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: userAlbumFetchOptions)
        //userCollections = PHCollectionList.fetchTopLevelUserCollections(with: userAlbumFetchOptions) as? PHFetchResult<PHAssetCollection>
        
        PHPhotoLibrary.shared().register(self)
        tableView.reloadData()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension LibraryController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .allPhotos: return 1
        case .smartAlbums: return smartAlbums.count
        case .userCollections: return userCollections.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(reusable: UITableViewCell.self, for: indexPath)
    }
}

extension LibraryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionLocalizedTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            cell.textLabel?.text = NSLocalizedString("All Photos", comment: "")
            cell.detailTextLabel?.text = String(allPhotos.count)
        case .smartAlbums:
            let collection = smartAlbums.object(at: indexPath.row)
            cell.textLabel?.text = collection.localizedTitle
            cell.detailTextLabel?.text = String(smartAlbumsFetchAssets[indexPath.row].count)
        case .userCollections:
            let collection = userCollections.object(at: indexPath.row)
            cell.textLabel?.text = collection.localizedTitle
            cell.detailTextLabel?.text = String(collection.estimatedAssetCount)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension LibraryController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            /// Check each of the three top-level fetches for changes.
            
            /// allPhotos
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.allPhotos.rawValue), with: .automatic)
            }
            
            /// smartAlbums
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue), with: .automatic)
            } else {
                /// update smartAlbums fetches
                for i in 0..<smartAlbumsFetchAssets.count {
                    let fetchAssets = smartAlbumsFetchAssets[i]
                    if let changeDetails = changeInstance.changeDetails(for: fetchAssets) {
                        smartAlbumsFetchAssets[i] = changeDetails.fetchResultAfterChanges
                    }
                    /// can be checked for changes and reload if need
                    tableView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue), with: .automatic)
                }
            }
            
            /// userCollections
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.userCollections.rawValue), with: .automatic)
            }
        }
    }
    
}

extension PHAssetCollection {
    /// if mediaType set .unknown, means fetch all objects
    func fetchAssets(of mediaType: PHAssetMediaType) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "\(#keyPath(PHAsset.mediaType)) == %d", mediaType.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "\(#keyPath(PHAsset.creationDate))", ascending: false)]
        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeiTunesSynced, .typeCloudShared]
        return PHAsset.fetchAssets(in: self, options: fetchOptions)
    }
    
    func fetchPhotosAndVideos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        let fetchKey = #keyPath(PHAsset.mediaType)
        fetchOptions.predicate = NSPredicate(format: "\(fetchKey) == %d || \(fetchKey) == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "\(#keyPath(PHAsset.creationDate))", ascending: false)]
        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeiTunesSynced, .typeCloudShared]
        return PHAsset.fetchAssets(in: self, options: fetchOptions)
    }
    
    //return fetchAssets(predicate: predicate)
    func fetchAssets(predicate: NSPredicate?) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = predicate
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "\(#keyPath(PHAsset.creationDate))", ascending: false)]
        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeiTunesSynced, .typeCloudShared]
        return PHAsset.fetchAssets(in: self, options: fetchOptions)
    }
}


extension PHAssetCollection {
    
    var itemsCount: Int {
        /// source https://stackoverflow.com/a/47565215/5893286
        /// wors only with user albums, not with smart ones
        let estimatedCount = estimatedAssetCount
        if estimatedCount != NSNotFound {
            return estimatedCount
        }
        
        let fetchOptions = PHFetchOptions()
        //fetchOptions.predicate = NSPredicate(format: "\(#keyPath(PHAsset.mediaType)) == %d", PHAssetMediaType.image.rawValue)
        let result = PHAsset.fetchAssets(in: self, options: fetchOptions)
        return result.count
    }
    
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
    
}
