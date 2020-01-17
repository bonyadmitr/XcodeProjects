import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
    
    let titleLabel: UILabel = {
        /// newValue used for simplifying copying same settings
        let newValue = UILabel()
        newValue.font = UIFont.preferredFont(forTextStyle: .headline)
        newValue.backgroundColor = .systemBackground
        newValue.textColor = .label
        newValue.numberOfLines = 0
        return newValue
    }()
    
    private let edgeInsets: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isOpaque = true
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: edgeInsets,
                                  y: edgeInsets,
                                  width: bounds.width - edgeInsets * 2,
                                  height: bounds.height - edgeInsets * 2)
    }
}
