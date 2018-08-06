//
//  ViewController.swift
//  DragDrop
//
//  Created by Bondar Yaroslav on 8/3/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            let drop = UIDropInteraction(delegate: self)
            view.addInteraction(drop)
        } else {
            // Fallback on earlier versions
        }
    }
}

/// https://developer.apple.com/documentation/uikit/drag_and_drop/making_a_view_into_a_drop_destination
@available(iOS 11.0, *)
extension ViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
        //return session.canLoadObjects(ofClass: URL.self) || session.canLoadObjects(ofClass: UIImage.self)
    }
    
    /// .copy adds (+) icon for item
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
//        if let view = trashBarButtonItem.value(forKey: "view") as? UIView {
//            let dropPoint = session.location(in: view)
//            if abs(dropPoint.x) <= view.bounds.width && dropPoint.y <= view.bounds.height {
//                return UIDropProposal(operation: .move)
//            }
//        }
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            guard let images = imageItems as? [UIImage] else {
                return
            }
            self.photoImageView.image = images.first
        }
        
//        guard let item = session.items.first else { return }
//        guard let droppedImageURL = item.localObject as? URL else { return }
    }
}
