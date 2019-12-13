import UIKit

/// swift doc https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md
/// aricle https://www.vadimbulavin.com/swift-5-property-wrappers/
protocol Stylable {
    associatedtype StyleType
    
    /// used different func style instead of  @discardableResult
    func setStyle(_ style: StyleType)
}
//extension Stylable where Self: UILabel {
//    func setup() {
//        font = UIFont.preferredFont(forTextStyle: .headline)
//        textAlignment = .center
//        backgroundColor = .systemBackground
//        textColor = .label
//        numberOfLines = 1
//    }
//}

extension Stylable {
    func style(_ style: StyleType) -> Self {
        setStyle(style)
        return self
    }
}

extension UILabel: Stylable {
    typealias StyleType = Style
    
    enum Style {
        case title
        case subtitle
    }
    
    func setStyle(_ style: Style) {
        switch style {
        case .title:
            font = UIFont.preferredFont(forTextStyle: .headline)
        case .subtitle:
            font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        textAlignment = .center
        backgroundColor = .systemBackground
        textColor = .label
        numberOfLines = 1
    }
}

extension UIImageView: Stylable {
    typealias StyleType = Style
    
    enum Style {
        case kf
        case common
    }
    
    func setStyle(_ style: StyleType) {
        switch style {
        case .kf:
            kf.indicatorType = .activity
        case .common:
            //kf.indicatorType = .none
            break
        }
        contentMode = .scaleAspectFit
        isOpaque = true
        /// used color to show empty state bcz UIActivityIndicatorView is too expensive for performance
        backgroundColor = .systemBackground
        
        //newValue.clipsToBounds = true
    }
}

/// @Style(style: .subtitle)
/// { willSet { newValue.setStyle(.title) } }
@propertyWrapper
struct Style<T: Stylable> {
    
    var wrappedValue: T? {
        willSet { newValue?.setStyle(style) }
    }
    
    private let style: T.StyleType
    
    init(style: T.StyleType) {
        self.style = style
    }
    
    init(wrappedValue: T?, style: T.StyleType) {
        self.wrappedValue = wrappedValue
        self.style = style
    }
}

/// @Style2(style: .title)
/// private let label2 = UILabel().style(.title)
@propertyWrapper
struct Style2<T: Stylable> {
    let wrappedValue: T
    
    init(wrappedValue: T, style: T.StyleType) {
        wrappedValue.setStyle(style)
        self.wrappedValue = wrappedValue
    }
}

final class ProductDetailView: UIView {
    
    typealias Item = ProductItemDB
    
    @Style(style: .kf)
    @IBOutlet private var imageView: UIImageView!
    
    @Style(style: .title)
    @IBOutlet private var nameLabel: UILabel!
    
    @Style(style: .subtitle)
    @IBOutlet private var priceLabel: UILabel!
    
    @Style(style: .subtitle)
    @IBOutlet private var descriptionLabel: UILabel!
    
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
