//
//  CircularProgressView.swift
//  CircularProgressView
//
//  Created by Yaroslav Bondar on 12.11.2021.
//

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
    
    func setMinimumNotZeroProgress() {
        setProgress(0.0001, animationOption: .none)
    }
    
    func stopAnimations() {
        progressLayer.removeAllAnimations()
    }
    
    // MARK: - private functions
    
    private func setProgressWithoutAnimation(_ progress: CGFloat) {
        let progress = clampedProgress(from: progress)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = progress
        CATransaction.commit()
    }
    
    private func setProgressLinearAnimation(_ progress: CGFloat) {
        let progress = clampedProgress(from: progress)
        let duration = abs(progress - animationProgress) * maxLinearAnimationDuration
        setProgress(progress, animationDuration: duration)
    }
    
    private func setProgress(_ progress: CGFloat, animationDuration: CGFloat) {
        let progress = clampedProgress(from: progress)
        
        /// Restarting animation https://stackoverflow.com/a/27074434/5893286
        /// Restarting animation https://stackoverflow.com/a/6046169/5893286
        if UIApplication.shared.applicationState == .background {
            setProgressInBackgroundStartedTime = CACurrentMediaTime()
            progressInBackground = progress
            animationDurationInBackground = animationDuration
            progressLayer.strokeEnd = animationProgress
            stopAnimations()
            return
        }
        
        /// save current progress
        progressLayer.strokeEnd = animationProgress
        
        let animationKey = #keyPath(CAShapeLayer.strokeEnd)
        progressLayer.removeAnimation(forKey: animationKey)
        
        let animation = CABasicAnimation(keyPath: animationKey)
        animation.duration = animationDuration
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = progress
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: animationKey)
    }
    
    private func setup() {
        setupLayers()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWilllEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
  
        
        self.addSubview(imageView)
        imageView.layer.anchorPoint = CGPoint(x: 0.4, y: 0.7)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.simulateProgress()
//            self.setProgress(0.5)
        }
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
//            animation.duration = 3
//            animation.repeatCount = MAXFLOAT
//                        animation.path = self.circleLayer.path
//
//            let imageView = UIImageView(image: UIImage(named: "iconCleaning"))
//            self.addSubview(imageView)
//            imageView.layer.anchorPoint = CGPoint(x: 0.4, y: 0.7)
//            imageView.layer.add(animation, forKey: nil)
//        }
    }
    
    let imageView = UIImageView(image: UIImage(named: "iconCleaning"))
    
    func simulateProgress() {
        
        var progress: CGFloat = 0
        
        DispatchQueue.global().async {
            for _ in 1...10000 {
                progress += 0.002
                if progress > 1 {
                    progress = 0
                }
                Thread.sleep(forTimeInterval: 0.01)
                DispatchQueue.main.async {
                    if progress > 0.95 {
                        self.imageView.isHidden = true
                    } else {
                        self.imageView.isHidden = false
                    }
                    self.setIconProgress(progress)
                    self.setProgress(progress, animationOption: .none)
                }
            }

        }
        
    }
    
    func setIconProgress(_ progress: CGFloat) {
        let angle = progress * (endPoint - startPoint) + startPoint + CGFloat.pi / 20
        let radius = min(bounds.midX, bounds.midY) - ringWidth * 0.5
        
        let sinAngle = sin(angle)
        
        let Xdiff: CGFloat = sinAngle * 4
//        let ydiff: CGFloat = abs(sinAngle) * 4
        
        let x = bounds.midX + radius * cos(angle) - Xdiff
        let y = bounds.midY + radius * sin(angle) - Xdiff
        
        imageView.layer.position = CGPoint(x: x, y: y)
    }
    
    @objc private func applicationWilllEnterForeground() {
        restoreAnimationIfNeed()
    }
    private func setProgressWithoutAnimation(_ progress: CGFloat) {
        let progress = clampedProgress(from: progress)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = progress
        CATransaction.commit()
    }
    private func setProgressWithoutAnimation(_ progress: CGFloat) {
        let progress = clampedProgress(from: progress)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = progress
        CATransaction.commit()
    }
    
}
