//
//  ProductDetailController.swift
//  ProductsList
//
//  Created by Bondar Yaroslav on 11/15/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ProductDetailController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var imageView: UIImageView! {
        willSet {
            /// newValue used for simplifying copying same settings
            
            newValue.contentMode = .scaleAspectFit
            newValue.isOpaque = true
            
            /// used color to show empty state bcz UIActivityIndicatorView is too expensive for performance
            newValue.backgroundColor = .systemBackground
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel! {
        willSet {
            /// newValue used for simplifying copying same settings
            newValue.font = UIFont.preferredFont(forTextStyle: .headline)
            newValue.textAlignment = .center
            newValue.backgroundColor = .systemBackground
            newValue.textColor = .label
            newValue.numberOfLines = 1
        }
    }
    
    @IBOutlet private weak var priceLabel: UILabel! {
        willSet {
            /// newValue used for simplifying copying same settings
            newValue.font = UIFont.preferredFont(forTextStyle: .body)
            newValue.textAlignment = .center
            newValue.backgroundColor = .systemBackground
            newValue.textColor = .label
            newValue.numberOfLines = 1
        }
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel! {
        willSet {
            /// newValue used for simplifying copying same settings
            newValue.font = UIFont.preferredFont(forTextStyle: .caption2)
            newValue.textAlignment = .center
            newValue.backgroundColor = .systemBackground
            newValue.textColor = .label
            newValue.numberOfLines = 0
        }
    }
    
    var item: Product.Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        automaticallyAdjustsScrollViewInsets = true
        
//        if #available(iOS 11.0, *) {
//            scrollView.contentInsetAdjustmentBehavior = .never
//        } else {
//            automaticallyAdjustsScrollViewInsets = false
//        }
        
        guard let item = item else {
            assertionFailure()
            return
        }
        setup(for: item)
    }
    
    private func setup(for item: Product.Item) {
        title = item.name
        
        nameLabel.text = item.name
        priceLabel.text = "\(item.price)"
        
        // TODO: fill descriptionLabel
        descriptionLabel.text = ""
        
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: item.imageUrl, placeholder: UIImage(systemName: "photo"))
    }
    
}
