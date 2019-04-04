import UIKit

/// https://stackoverflow.com/a/42866766
final class TransparentGradientView: UIView {
    
    private let gradientMask = CAGradientLayer()
    
    /// animated
    var style = TransparentGradientStyle.vertical {
        didSet {
            setupStyle()
        }
    }
    
    enum TransparentGradientStyle {
        case vertical
        case horizontal
    }
    
    init(style: TransparentGradientStyle, mainColor: UIColor) {
        /// will not call didSet
        self.style = style
        
        self.init()
        backgroundColor = mainColor
    }
    
    /// setup backgroundColor to change color of gradient
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /// setup backgroundColor to change color of gradient
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setupStyle() {
        switch style {
        case .vertical:
            gradientMask.startPoint = CGPoint(x: 0, y: 0)
            gradientMask.endPoint = CGPoint(x: 0, y: 1)
            
        case .horizontal:
            gradientMask.startPoint = CGPoint(x: 0, y: 0)
            gradientMask.endPoint = CGPoint(x: 1, y: 0)
        }
    }
    
    private func setup() {
        setupStyle()
        
        let anyNotClearColor = UIColor.white
        gradientMask.colors = [UIColor.clear.cgColor, anyNotClearColor, anyNotClearColor.cgColor]
        
        /// 0 - 0.1 is 10% of view will be UIColor.clear
        gradientMask.locations = [NSNumber(value: 0), NSNumber(value: 0.1), NSNumber(value: 1)]
        layer.mask = gradientMask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientMask.frame = bounds
    }
}
