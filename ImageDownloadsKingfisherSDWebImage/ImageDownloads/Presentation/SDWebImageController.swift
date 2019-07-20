//
//  SDWebImageController.swift
//  ImageDownloads
//
//  Created by Bondar Yaroslav on 07/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import SDWebImage

class SDWebImageController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    lazy var urls: [URL] = {
        return (1...150)
            .map { "https://placehold.it/1200x1200&text=\($0)"}
            ///"https://dummyimage.com/600x40\(indexPath.row)/000/fff"
            .compactMap { URL(string: $0) }
    }()
    
    @IBAction func actionClearBarButton(_ sender: UIBarButtonItem) {
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk {
            self.collectionView.reloadData()
        }
    }
}

extension SDWebImageController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
//        cell.imageImageView.sd_setIndicatorStyle(.white)
//        cell.imageImageView.sd_addActivityIndicator()
//        cell.imageImageView.sd_setImage(with: urls[indexPath.row])
        return cell
    }
}

extension SDWebImageController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ImageCell

        cell.imageImageView.sd_setIndicatorStyle(.white)
        cell.imageImageView.sd_addActivityIndicator()
        cell.imageImageView.sd_setImage(with: urls[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ImageCell
        cell.imageImageView.sd_cancelCurrentImageLoad()
    }
}

extension SDWebImageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 6 - 5, height: 50)
    }
}
