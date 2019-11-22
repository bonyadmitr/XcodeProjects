import UIKit

/// inspire by https://stackoverflow.com/a/50997110/5893286
/// don't set height to the UIImageView in xib. set intrisic size by placeholder to remove layout errors
final class ScaledHeightImageView: UIImageView {
    
    private lazy var heightConstraint = heightAnchor.constraint(equalToConstant: 100)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint.isActive = true
    }
    
    override var image: UIImage? {
        didSet {
            updateHeight()
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateHeight()
    }
    
    private func updateHeight() {
        guard let image = image else {
            return
        }
        
        let ratio = image.size.height / image.size.width
        //let newHeight = min(bounds.height * 0.5, bounds.width * ratio)
        let newHeight = bounds.width * ratio
        heightConstraint.constant = newHeight
    }
    
}
