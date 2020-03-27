//
//  LibraryController.swift
//  Images
//
//  Created by Bondar Yaroslav on 11/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Photos

final class AlbumsController: UIViewController {
    
    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections
        
        static let count = 3
    }
    
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
