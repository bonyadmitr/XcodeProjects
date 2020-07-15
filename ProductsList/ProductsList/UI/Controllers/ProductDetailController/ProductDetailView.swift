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

import UIKit

extension UIView {
    
    static func loadView() -> Self {
        if isNibExist() {
            return loadFromNib()
        } else {
            return self.init(frame: UIScreen.main.bounds)
        }
    }
    
    static func loadFromNib() -> Self {
        
        let selfClass: AnyClass = self as AnyClass
        var className = NSStringFromClass(selfClass)
        let bundle = Bundle(for: selfClass)
        
        if bundle.path(forResource: className, ofType: "nib") == nil {
            className = (className as NSString).pathExtension
            if bundle.path(forResource: className, ofType: "nib") == nil {
                fatalError("No xib file for view \(type(of: self))")
            }
        }
        
        return view(bundle, className: className)
    }
    
    
    func loadNib(nibName: String? = nil) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = nibName ?? type(of: self).description().components(separatedBy: ".").last!
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView // swiftlint:disable:this force_cast
    }
    
}

