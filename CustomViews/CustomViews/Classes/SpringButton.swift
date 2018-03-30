import UIKit

/// A UIButton subclass that renders a springy animation when tapped.
/// If the damping parameters are set to 1.0, this class may be used to provide subtle feedback to buttons with no elsasticity.
/// - parameter minimumScale: The minimum scale that the button may reach while pressed. Default 0.95
/// - parameter pressSpringDamping: The damping parameter for the spring animation used when the button is pressed. Default 0.4
/// - parameter releaseSpringDamping: The damping parameter for the spring animation used when the button is released. Default 0.35
/// - parameter pressSpringDuration: The duration of the spring animation used when the button is pressed. Default 0.4
/// - parameter releaseSpringDuration: The duration of the spring animation used when the button is reloeased. Default 0.5

open class SpringButton: UIButton {
    
    open var minimumScale: CGFloat = 0.98
    
    //--- for spring button
    
//    open var pressSpringDamping: CGFloat = 0.4
//    open var releaseSpringDamping: CGFloat = 0.35
//    open var pressSpringDuration = 0.5
//    open var releaseSpringDuration = 0.6
    //---
    
    //--- for default 3D button
    
    open var pressSpringDamping: CGFloat = 1
    open var releaseSpringDamping: CGFloat = 1
    open var pressSpringDuration = 0.1
    open var releaseSpringDuration = 0.1
    //---
    
    private var savedBackgroundColor: UIColor?
    private var darkerBackgroundColor: UIColor?
    private let cornerRadius: CGFloat = 5
    private let animationOptions: UIViewAnimationOptions = [.curveLinear, .allowUserInteraction]
    
    private let shadowRadiusMin: CGFloat = 0
    private let shadowRadiusMax: CGFloat = 1
    private let shadowOffsetMin = CGSize()
    private let shadowOffsetMax = CGSize(width: 2, height: 2)
    
    // MARK: - Init
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupShadow()
        setupBackgroundColors()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        addShadowPath()
    }
    
    override open var isHighlighted: Bool {
        didSet {
            switch isHighlighted {
            case true:
                backgroundColor = darkerBackgroundColor
            case false:
                backgroundColor = savedBackgroundColor
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        layer.cornerRadius = cornerRadius
    }
    
    private func setupShadow() {
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        addShadow()
//        layer.shouldRasterize = true //optimization if needed
    }
    
    private func setupBackgroundColors()  {
        savedBackgroundColor = backgroundColor
        darkerBackgroundColor = backgroundColor?.darker(by: 10)
    }
    
    // MARK: - Shadow
    
    fileprivate func addShadow() {
        layer.shadowOffset = shadowOffsetMax
        layer.shadowRadius = shadowRadiusMax
    }
    
    private func addShadowPath() { //optimization
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
    fileprivate func removeShadow() {
        layer.shadowOffset = shadowOffsetMin
        layer.shadowRadius = shadowRadiusMin
    }
    
    // MARK: - Animations
    
    private func touchInAnimation() {
        UIView.animate(withDuration: pressSpringDuration, delay: 0, usingSpringWithDamping: pressSpringDamping, initialSpringVelocity: 0, options: animationOptions, animations: {
            self.transform = CGAffineTransform(scaleX: self.minimumScale, y: self.minimumScale)
            self.removeShadow()
        }, completion: nil)
    }
    
    private func touchOutAnimation() {
        UIView.animate(withDuration: releaseSpringDuration, delay: 0, usingSpringWithDamping: releaseSpringDamping, initialSpringVelocity: 0, options: animationOptions, animations: {
            self.transform = .identity
            self.addShadow()
        }, completion: nil)
    }
    
    // MARK: - Touches
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchInAnimation()
    }
    
    // for touch out of button animation
    
//    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesMoved(touches, with: event)
//        let location = touches.first!.location(in: self)
//        bounds.contains(location) ? touchInAnimation() : touchOutAnimation()
//    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchOutAnimation()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchOutAnimation()
    }
}
