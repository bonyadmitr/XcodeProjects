//
//  LocalPhotosController.swift
//  Images
//
//  Created by Bondar Yaroslav on 28/01/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: fix bottom insets

final class LocalPhotosController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var photoManager = PhotoManager()
    private lazy var permissionsManager = PermissionsManager()
    private lazy var settingsRouter = SettingsRouter()
    
    private let photoViewerSegue = "PhotoViewer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        
        permissionsManager.requestPhotoAccess { [weak self] status in
            guard let `self` = self else { return }
            
            switch status {
            case .success:
                self.photoManager.resetCachedAssets()
                self.photoManager.delegate = self
                self.photoManager.prepereForUse()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .denied:
                self.settingsRouter.presentSettingsAlertForPhotoAccess(in: self)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateItemSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateItemSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        photoManager.updateCachedAssetsFor(collectionView: collectionView)
    }
    
    /// Determine the size of the thumbnails to request from the PHCachingImageManager
    private func updateItemSize() {
        let size = saveAndGetItemSize(for: collectionView)
        let scale = UIScreen.main.scale
        photoManager.photoSize = CGSize(width: size.width * scale, height: size.height * scale)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == photoViewerSegue,
            let vc = segue.destination as? PhotoViewerController,
            let indexPath = sender as? IndexPath,
            let asset = photoManager.fetchResult?[indexPath.item]
        else {
            return
        }
        
        vc.asset = asset
    }
}

extension LocalPhotosController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetch = photoManager.fetchResult else {
            return 0
        }
        return fetch.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: PhotoCell.self, for: indexPath)
        photoManager.fill(cell: cell, for: indexPath)
        return cell
    }
}
extension LocalPhotosController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: photoViewerSegue, sender: indexPath)
    }
}
extension LocalPhotosController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        photoManager.updateCachedAssetsFor(collectionView: collectionView)
    }
}

extension LocalPhotosController: PhotoManagerColectionViewDelegate { }
