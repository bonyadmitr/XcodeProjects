//
//  ImageTextCell.swift
//  ProductsList
//
//  Created by Bondar Yaroslav on 11/15/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// Content View added for simplifying copying of all content and possible insets
/// changed subtitleLabel content hugging priority and content compression resistance
final class ImageTextCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView! {
        willSet {
            /// newValue used for simplifying copying same settings
            
            newValue.contentMode = .scaleAspectFill
            newValue.isOpaque = true
            
            /// used color to show empty state bcz UIActivityIndicatorView is too expensive for performance
            newValue.backgroundColor = .lightGray
        }
    }
    
    
    @IBOutlet private weak var titleLabel: UILabel! {
        willSet {
            /// newValue used for simplifying copying same settings
            newValue.font = UIFont.preferredFont(forTextStyle: .body)
            newValue.textAlignment = .center
            newValue.backgroundColor = backgroundColor
            newValue.textColor = .label
            newValue.numberOfLines = 1
        }
    }
    
    @IBOutlet private weak var subtitleLabel: UILabel! {
        willSet {
            /// newValue used for simplifying copying same settings
            newValue.font = UIFont.preferredFont(forTextStyle: .caption2)
            newValue.textAlignment = .center
            newValue.backgroundColor = backgroundColor
            newValue.textColor = .label
            newValue.numberOfLines = 1
        }
    }

}
