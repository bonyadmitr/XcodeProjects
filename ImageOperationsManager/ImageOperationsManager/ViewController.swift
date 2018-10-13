//
//  ViewController.swift
//  ImageOperationsManager
//
//  Created by Bondar Yaroslav on 10/13/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class CollectionController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
            newValue.register(ImageTextColCell.self, forCellWithReuseIdentifier: "ImageTextColCell")
            newValue.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionHeader")
            
            newValue.alwaysBounceVertical = true
            
            if let layout = newValue.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 1
                layout.minimumInteritemSpacing = 1
                layout.sectionInset = .init(top: 1, left: 1, bottom: 1, right: 1)
            }
        }
    }
    
    private var photos = [WebPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readJson()
        
        collectionView.reloadData()
    }
    
    private func readJson() {
        guard
            let file = Bundle.main.url(forResource: "photos", withExtension: "json"),
            let data = try? Data(contentsOf: file),
            let photos = try? JSONDecoder().decode([WebPhoto].self, from: data)
        else {
            assertionFailure()
            return
        }
        self.photos = photos
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension CollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "ImageTextColCell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeader", for: indexPath)
    }
}

extension CollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageTextColCell else {
            assertionFailure()
            return
        }
        cell.imageView.image = nil
        let photo = photos[indexPath.row]
        ImageOperationsManager.shared.load(webPhoto: photo) { webPhoto, image in
            if webPhoto == photo, let image = image {
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        ImageOperationsManager.shared.cancel(webPhoto: photos[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        print(photo.thumbnailUrl)
    }
}

extension CollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4 - 3
        return CGSize(width: width, height: width)
    }
}

final class ImageTextColCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.lightGray
        
        imageView.frame = bounds
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        textLabel.frame = bounds
        textLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.numberOfLines = 0
        
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
        imageView.frame = bounds
    }
}

final class CollectionHeader: UICollectionReusableView {
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.darkGray
        
        textLabel.frame = bounds
        textLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textLabel.textAlignment = .left
        textLabel.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
    }
}
