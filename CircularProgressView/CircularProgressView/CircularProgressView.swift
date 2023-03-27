import UIKit

/// another solution https://github.com/luispadron/UICircularProgressRing/tree/master/Legacy
final class CircularProgressView: UIView {
    
    /// can be added Configuration for public properties
    /// `slight animatable on change` can be removed by disabling layers animations
    
    enum AnimationOption {
        case none
        case linearAnimation
        case animation(duration: CGFloat)
    }
    
    // MARK: - public properties
    
    /// slight animatable on change
    var ringWidth: CGFloat = 20 {
        didSet {
            circleLayer.lineWidth = ringWidth
            progressLayer.lineWidth = ringWidth
            setNeedsLayout()
        }
    }
    
    /// slight animatable on change
    var circleColor = UIColor.white {
        didSet {
            circleGradientLayer.colors = [circleColor.withAlphaComponent(0.3).cgColor, circleColor.cgColor]
            circleGradientLayer.opacity = 0.4
        }
    }
    
}
