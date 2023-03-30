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
    
    /// from bottom to top
    var circleColors = [UIColor]() {
        didSet {
            circleGradientLayer.colors = circleColors.map { $0.cgColor }
            circleGradientLayer.opacity = 1
        }
    }
    
    /// slight animatable on change
    var progressColor = UIColor.lightGray {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    /// max for progress from 0 to 100 (and 100 to 0)
    var maxLinearAnimationDuration: CGFloat = 2
    
    // MARK: - private properties
    
    private let circleLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let circleGradientLayer = CAGradientLayer()
    
    private let startPoint = -CGFloat.pi / 2
    private let endPoint = 3 * CGFloat.pi / 2
    
    private var setProgressInBackgroundStartedTime: CFTimeInterval = 0
    private var progressInBackground: CGFloat = 0
    private var animationDurationInBackground: CGFloat = 0
    
}
