//
//  ProductDetailController.swift
//  ProductsList
//
//  Created by Bondar Yaroslav on 11/15/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreData

final class ProductDetailController: UIViewController {
    
    typealias Model = Product
    typealias Item = ProductItemDB
    
    private let service = Model.Service()
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var imageView: UIImageView! {
        willSet {
            /// newValue used for simplifying copying same settings
            
            newValue.contentMode = .scaleAspectFit
            newValue.isOpaque = true
            
            /// used color to show empty state bcz UIActivityIndicatorView is too expensive for performance
            newValue.backgroundColor = .systemBackground
            
            //newValue.clipsToBounds = true
            newValue.kf.indicatorType = .activity
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel! {
        willSet {
            /// newValue used for simplifying copying same settings
            newValue.font = UIFont.preferredFont(forTextStyle: .headline)
            //newValue.textAlignment = .center
            newValue.backgroundColor = .systemBackground
            newValue.textColor = .label
            newValue.numberOfLines = 1
        }
    }
    
    @IBOutlet private weak var priceLabel: UILabel! {
        willSet {
            /// newValue used for simplifying copying same settings
            newValue.font = UIFont.preferredFont(forTextStyle: .body)
            //newValue.textAlignment = .center
            newValue.backgroundColor = .systemBackground
            newValue.textColor = .label
            newValue.numberOfLines = 1
        }
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel! {
        willSet {
            /// newValue used for simplifying copying same settings
            newValue.font = UIFont.preferredFont(forTextStyle: .body)
            //newValue.textAlignment = .left
            newValue.backgroundColor = .systemBackground
            newValue.textColor = .label
            newValue.numberOfLines = 0
            newValue.text = ""
            newValue.isHidden = true
        }
    }
    
    var item: Item?
    
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
    
    private func setup(for item: Item) {
        title = item.name
        
        nameLabel.text = item.name
        priceLabel.text = "Price: \(item.price)"
        
        if let description = item.detail {
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
        }
        
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: item.imageUrl, placeholder: UIImage(systemName: "photo"))
        
        guard let id = item.id else {
            assertionFailure()
            return
        }
        
        service.detail(id: id) { [weak self] result in
            switch result {
            case .success(let detailedItem):
                self?.handle(detailedItem: detailedItem)
                
            case .failure(let error):
                print(error.debugDescription)
            }
        }
    }
    
    private func handle(detailedItem: Product.DetailItem) {
        DispatchQueue.main.async {
            self.descriptionLabel.isHidden = false
            self.descriptionLabel.text = detailedItem.description
        }
        
        /// save
        
        guard let item = item, let context = item.managedObjectContext else {
            assertionFailure()
            return
        }
        
        context.perform {
            item.detail = detailedItem.description
            
            do {
                try context.save()
            } catch {
                assertionFailure(error.debugDescription)
            }
        }
    }
}
