import UIKit

/// about Apple's corner radius: https://hackernoon.com/apples-icons-have-that-shape-for-a-very-good-reason-720d4e7c8a14
/// optimized code from: https://github.com/lapfelix/UIView-SmoothCorners
final class AppleCornerRadiusView: UIView {
    
    override class var layerClass: AnyClass {
        return AppleCornerRadiusLayer.self
    }
}

final class AppleCornerRadiusLayer: CALayer {
    
    private let _mask = CAShapeLayer()
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.mask = _mask
        updateMaskPath()
    }
    
    override var cornerRadius: CGFloat {
        didSet {
            updateMaskPath()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            if bounds != oldValue {
                updateMaskPath()
            }
        }
    }
    
    private func updateMaskPath() {
        _mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
}
