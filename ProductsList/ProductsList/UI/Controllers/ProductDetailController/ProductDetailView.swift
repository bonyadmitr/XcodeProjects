import UIKit

final class ProductDetailView: UIView {
    
    typealias Item = ProductItemDB
    
    @Style(style: .kf)
    @IBOutlet private var imageView: UIImageView!
    
    @Style(style: .title)
    @IBOutlet private var nameLabel: UILabel!
    
    @Style(style: .subtitle)
    @IBOutlet private var priceLabel: UILabel!
    
    @Style(style: .subtitle)
    @IBOutlet private var descriptionLabel: UILabel! {
        willSet {
            newValue.isHidden = true
        }
    }
    
    func setup(for item: Item) {
        nameLabel.text = item.name
        priceLabel.text = "Price: \(item.price)"
        
        if let description = item.detail {
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
        }
        
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: item.imageUrl, placeholder: UIImage(systemName: "photo"))
    }
    
    func setupDetail(from detailedItem: Product.DetailItem) {
        descriptionLabel.isHidden = false
        descriptionLabel.text = detailedItem.description
    }
}
