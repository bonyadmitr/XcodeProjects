//
//  PhotoCell.swift
//  DragDrop
//
//  Created by Bondar Yaroslav on 8/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    
    @IBOutlet private weak var photoImageView: UIImageView!
    
    func config(with object: UIImage?) {
        photoImageView.image = object
    }
}
