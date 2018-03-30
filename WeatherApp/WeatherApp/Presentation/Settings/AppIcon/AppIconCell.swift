//
//  AppIconCell.swift
//  AlternateIcon
//
//  Created by Bondar Yaroslav on 13/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class AppIconCell: UICollectionViewCell {
    
    
    var iconImageView: UIImageView!
    
    /// 512/80 == 114/18 == 72/11 == 57/9 == 6.4
    private let iconRadiusRatio: CGFloat = 6.4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        iconImageView = UIImageView(frame: bounds)
        iconImageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        iconImageView.clipsToBounds = true
        addSubview(iconImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.bounds.width / iconRadiusRatio
    }
}
