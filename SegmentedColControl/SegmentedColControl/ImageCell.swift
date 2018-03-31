//
//  ImageCell.swift
//  SegmentedColControl
//
//  Created by Bondar Yaroslav on 28/03/2017.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    var iconImageView: UIImageView!
    
    func setup() {
        iconImageView = UIImageView(frame: bounds)
        iconImageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        iconImageView.contentMode = .center
        addSubview(iconImageView)
    }
}
