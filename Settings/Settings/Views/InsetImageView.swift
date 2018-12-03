import Foundation
import UIKit

final class InsetImageView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return imageView
    }()
    
    var insets = UIEdgeInsets.zero {
        didSet { layoutIfNeeded() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: insets.left,
                                 y: insets.top,
                                 width: bounds.size.width - insets.right - insets.left,
                                 height: bounds.size.height - insets.bottom - insets.top)
    }
    
    private func setup() {
        addSubview(imageView)
    }
}
