//
//  PhotosController.swift
//  DragDrop
//
//  Created by Bondar Yaroslav on 8/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class PhotosController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            
            if #available(iOS 11.0, *) {
                /// By default, For iPad this will return YES and iPhone will return NO
                //collectionView.dragInteractionEnabled = true
                
                //collectionView.reorderingCadence = .slow
            } else {
                // Fallback on earlier versions
            }
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

//extension PhotosController: UICollectionViewDropDelegate {
//    
//}
