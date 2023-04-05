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
    
    // MARK: - override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayersPath()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        /// cgColor update https://stackoverflow.com/a/58312205/5893286
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            circleLayer.strokeColor = circleColor.cgColor
            progressLayer.strokeColor = progressColor.cgColor
        }
        
    }
    
    // MARK: - public functions
    
    func setProgress(_ progress: CGFloat, animationOption: AnimationOption) {
        switch animationOption {
        case .none:
            setProgressWithoutAnimation(progress)
        case .linearAnimation:
            setProgressLinearAnimation(progress)
        case .animation(let duration):
            setProgress(progress, animationDuration: duration)
        }
    }
}
