//
//  ViewController.swift
//  ImageDownloads
//
//  Created by Bondar Yaroslav on 07/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOS 10.0, *) {
//            collectionView.prefetchDataSource = self
//        }
        

        
        
        let days3: TimeInterval = 60 * 60 * 24 * 3 /// Default 1 week
        ImageCache.default.maxCachePeriodInSecond = days3
        
//        ImageCache.default.maxMemoryCost = 1
        
        ImageDownloader.default.downloadTimeout = 30.0 /// Default is 15 seconds
        
//        let mb50: UInt = 50 * 1024 * 1024 /// Default no limit
//        ImageCache.default.maxDiskCacheSize = mb50
    }
    
    @IBAction func actionClearBarButton(_ sender: UIBarButtonItem) {
        /// for user actions and tests
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            self.collectionView.reloadData()
        }
        //ImageCache.default.cleanExpiredDiskCache()
        
    }
    
    lazy var urls: [URL] = {        
        return (1...150)
            .map { "https://placehold.it/1200x1200&text=\($0)"}
            ///"https://dummyimage.com/600x40\(indexPath.row)/000/fff"
            .compactMap { URL(string: $0) }
    }()
    
    let processor = OverlayImageProcessor(overlay: UIColor.red) >> RoundCornerImageProcessor(cornerRadius: 30)
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.imageImageView.kf.setImage(with: urls[indexPath.row], placeholder: cell.activityPlaceholder, options: [.transition(.fade(0.3)), .processor(processor)])
        return cell
    }
}
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let cell = cell as! ImageCell
        
        /// 1 indicator
//        cell.imageImageView.kf.setImage(with: urls[indexPath.row], placeholder: cell.activityPlaceholder, options: [.transition(.fade(0.3)), .processor(processor)])
        
        /// 2 indicator
//        cell.imageImageView.kf.indicatorType = .custom(indicator: MyIndicator())
//        cell.imageImageView.kf.setImage(with: urls[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ImageCell
        cell.imageImageView.kf.cancelDownloadTask()
//        cell.imageImageView.kf.setImage(with:  urls[indexPath.row], placeholder: ActivityPlaceholder(), options: [.downloadPriority(0.001)])
        
        
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 6 - 5, height: 50)
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let subUrls = indexPaths
            .map { urls[$0.row]}
        ImagePrefetcher(urls: subUrls).start()
        
    }
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        /// wrong action. don't use
//        let subUrls = indexPaths
//            .map { urls[$0.row]}
//        ImagePrefetcher(urls: subUrls).stop()
    }
}
