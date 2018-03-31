//
//  CircleView.swift
//  CircleProgress
//
//  Created by Bondar Yaroslav on 3/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class CircleView: UIView {
    
    private let progressCircle = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    var lineWidth: CGFloat = 5.0 {
        didSet {
            progressCircle.lineWidth = lineWidth
            setNeedsLayout()
        }
    }
    
    var startColor: UIColor = .magenta {
        didSet {
            updateGradientColors()
        }
    }
    
    var endColor: UIColor = .cyan {
        didSet {
            updateGradientColors()
        }
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        if layer == self.layer {
            updateLayersFrame()
        }
    }
    
    private func updateLayersFrame() {
        progressCircle.frame = layer.bounds
        gradientLayer.frame = layer.bounds
        
        let radius = (bounds.width < bounds.height ? bounds.width : bounds.height) / 2
        let arcCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: radius - lineWidth / 2,
                                startAngle: -CGFloat.pi * 7 / 4,
                                endAngle: CGFloat.pi / 4, clockwise: true)
        
        progressCircle.path = path.cgPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        progressCircle.strokeColor = UIColor.white.cgColor ///anyColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = lineWidth
        progressCircle.strokeEnd = 0
        
        let startPoint = CGPoint(x: 0, y: 1)
        let endPoint = CGPoint(x: 1, y: 0)
        
        updateGradientColors()
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.mask = progressCircle
        layer.addSublayer(gradientLayer)
    }
    
    func animate(to progress: CGFloat, animated: Bool = true) {
        if animated {
            progressCircle.strokeEnd = progress
            
            /// if need to set duration
            //            let animation = CABasicAnimation(keyPath: "strokeEnd")
            //            animation.fromValue = progressCircle.strokeEnd
            //            animation.toValue = progress
            //            animation.duration = 3
            //            animation.fillMode = kCAFillModeForwards
            //            animation.isRemovedOnCompletion = false
            //            progressCircle.add(animation, forKey: "ani")
        } else {
            CALayer.performWithoutAnimation {
                progressCircle.strokeEnd = progress
            }
        }
    }
}
