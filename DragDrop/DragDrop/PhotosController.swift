//
//  PhotosController.swift
//  DragDrop
//
//  Created by Bondar Yaroslav on 8/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://stackoverflow.com/questions/26542035/create-uiimage-with-solid-color-in-swift
public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}


final class PhotosController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
//            collectionView.hasActiveDrag = true
        }
    }
    
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = [UIColor.red, .black, .cyan, .green, .blue, .magenta].compactMap { UIImage(color: $0) }
        
        if #available(iOS 11.0, *) {
            let drop = UIDropInteraction(delegate: self)
            view.addInteraction(drop)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension PhotosController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.config(with: images[indexPath.row])
        return cell
    }
}

extension PhotosController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension PhotosController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 2 - 5
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

@available(iOS 11.0, *)
extension PhotosController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        session.loadObjects(ofClass: UIImage.self) { [weak self] imageItems in
            guard let newImages = imageItems as? [UIImage] else {
                return
            }
            self?.images.insert(contentsOf: newImages, at: 0)
            self?.collectionView.reloadData()
        }
    }
}
