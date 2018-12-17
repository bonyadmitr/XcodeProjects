//
//  LibraryController.swift
//  Images
//
//  Created by Bondar Yaroslav on 11/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Photos

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
    var userCollections: PHFetchResult<PHCollection>!
    
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
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
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
            cell.detailTextLabel?.text = String(collection.accessibilityElementCount())
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
                        /// can be checked for changes and reload only one time
                        tableView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue), with: .automatic)
                    }
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
        if mediaType == .unknown {
            return PHAsset.fetchAssets(in: self, options: nil)
        }
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", mediaType.rawValue)
        return PHAsset.fetchAssets(in: self, options: fetchOptions)
    }
}

