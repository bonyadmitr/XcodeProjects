//
//  ImageCell.swift
//  ImageDownloads
//
//  Created by Bondar Yaroslav on 07/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageImageView: UIImageView!
    let activityPlaceholder = ActivityPlaceholder()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blue
    }
    
    override func prepareForReuse() {
        imageImageView.image = nil
    }
}
