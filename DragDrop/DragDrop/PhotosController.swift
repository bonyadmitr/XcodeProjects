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
//                collectionView.dropDelegate = self
                //collectionView.dragDelegate = self
                
                /// By default, For iPad this will return YES and iPhone will return NO
                //collectionView.dragInteractionEnabled = true
                
                //collectionView.reorderingCadence = .slow
            } else {
                // Fallback on earlier versions
            }
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
            collectionView.addGestureRecognizer(longPressGesture)
        }
    }
    
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = [UIColor.red, .black, .cyan, .green, .blue, .magenta].compactMap { UIImage(color: $0) }
        
//        if #available(iOS 11.0, *) {
//            let drop = UIDropInteraction(delegate: self)
//            view.addInteraction(drop)
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)),
            let cell = collectionView.cellForItem(at: selectedIndexPath) as? PhotoCell
        else {
            return
        }
        switch(gesture.state) {
        case .began:
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            cell.setSelection(true)
        case .changed:
            /// can be fixed not for center
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
            cell.setSelection(false)
        case .cancelled, .possible, .failed:
            collectionView.cancelInteractiveMovement()
            cell.setSelection(false)
        }
        
//        case UIGestureRecognizerState.began:
//            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
//                break
//            }
//            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
//        case UIGestureRecognizerState.changed:
//            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
//        case UIGestureRecognizerState.ended:
//            collectionView.endInteractiveMovement()
//        default:
//            collectionView.cancelInteractiveMovement()
//        }
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
    
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movingImage = images.remove(at: sourceIndexPath.item)
        images.insert(movingImage, at: destinationIndexPath.item)
//        let obj = collectionViewData[sourceIndexPath.row]
//        collectionViewData.remove(at: sourceIndexPath.row)
//        collectionViewData.insert(obj, at: destinationIndexPath.row)
//        updateAllVisibleCell()
    }
}

extension PhotosController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellWidth = collectionView.frame.width / 2 - 5
//        return CGSize(width: cellWidth, height: cellWidth)
        return CGSize(width: 100, height: 100)
    }
}

//@available(iOS 11.0, *)
//extension PhotosController: UIDropInteractionDelegate {
//    
//    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
//        return session.canLoadObjects(ofClass: UIImage.self)
//    }
//    
//    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
//        return UIDropProposal(operation: .copy)
//    }
//    
//    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
//        
//        session.loadObjects(ofClass: UIImage.self) { [weak self] imageItems in
//            guard let newImages = imageItems as? [UIImage] else {
//                return
//            }
//            self?.images.insert(contentsOf: newImages, at: 0)
//            self?.collectionView.reloadData()
//        }
//    }
//}

// MARK: - UICollectionViewDropDelegate
@available(iOS 11.0, *)
extension PhotosController: UICollectionViewDropDelegate {
    /* Called when the user initiates the drop.
     * Use the dropCoordinator to specify how you wish to animate the dropSession's items into their final position as
     * well as update the collection view's data source with data retrieved from the dropped items.
     * If the supplied method does nothing, default drop animations will be supplied and the collection view will
     * revert back to its initial pre-drop session state.
     */
    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        coordinator.session.loadObjects(ofClass: UIImage.self) { [weak self] imageItems in
            guard let newImages = imageItems as? [UIImage] else {
                return
            }
            self?.images.insert(contentsOf: newImages, at: 0)
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: Optional
    
    /* If NO is returned no further delegate methods will be called for this drop session.
     * If not implemented, a default value of YES is assumed.
     */
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    
    /* Called when the drop session begins tracking in the collection view's coordinate space.
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        
    }
    
    
    /* Called frequently while the drop session being tracked inside the collection view's coordinate space.
     * When the drop is at the end of a section, the destination index path passed will be for a item that does not yet exist (equal
     * to the number of items in that section), where an inserted item would append to the end of the section.
     * The destination index path may be nil in some circumstances (e.g. when dragging over empty space where there are no cells).
     * Note that in some cases your proposal may not be allowed and the system will enforce a different proposal.
     * You may perform your own hit testing via -[UIDropSession locationInView]
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy)
    }
    
    
    /* Called when the drop session is no longer being tracked inside the collection view's coordinate space.
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        
    }
    
    
    /* Called when the drop session completed, regardless of outcome. Useful for performing any cleanup.
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        
    }
    
    
    /* Allows customization of the preview used for the item being dropped.
     * If not implemented or if nil is returned, the entire cell will be used for the preview.
     *
     * This will be called as needed when animating drops via -[UICollectionViewDropCoordinator dropItem:toItemAtIndexPath:]
     * (to customize placeholder drops, please see UICollectionViewDropPlaceholder.previewParametersProvider)
     */
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return UIDragPreviewParameters()
    }
}
