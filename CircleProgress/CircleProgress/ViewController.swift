//
//  ViewController.swift
//  CircleProgress
//
//  Created by Bondar Yaroslav on 3/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension CALayer {
    static func performWithoutAnimation(actions: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        actions()
        CATransaction.commit()
    }
}




class ViewController: UIViewController {
    
    @IBOutlet weak var circleView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circleView.animate(to: 0.5, animated: false)
        
        circleView.lineWidth = 20
        circleView.startColor = .green
        circleView.endColor = .blue
    }

    @IBAction func actionProgrssSlider(_ sender: UISlider) {
        circleView.animate(to: CGFloat(sender.value), animated: true)
    }
}

//https://github.com/kaandedeoglu/KDCircularProgress
//https://github.com/maxkonovalov/MKGradientView
//https://github.com/paiv/AngleGradientLayer
//https://github.com/keygx/GradientCircularProgress/blob/master/Sources/GradientCircularProgress/Progress/Elements/GradientArcView.swift

final class CircleView2: UIView {
    
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
        layer.addSublayer(progressCircle)
        
        
                let radius = (bounds.width < bounds.height ? bounds.width : bounds.height) / 2
                let arcCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
                
                let path = UIBezierPath(arcCenter: arcCenter,
                                        radius: radius - lineWidth / 2,
                                        startAngle: -CGFloat.pi * 7 / 4,
                                        endAngle: CGFloat.pi / 4, clockwise: true)
                
                progressCircle.path = path.cgPath
        
        
        
        
                let colors : [UIColor] = self.graint(fromColor: startColor, toColor: endColor, count:4)
                for i in 0..<colors.count-1 {
                    let graint = CAGradientLayer()
                    graint.bounds = CGRect(origin:CGPoint.zero, size: CGSize(width:bounds.width/2,height:bounds.height/2))
                    let valuePoint = self.positionArrayWith(bounds: self.bounds)[i]
                    graint.position = valuePoint
                    print("iesimo graint position: \(graint.position)")
                    let fromColor = colors[i]
                    let toColor = colors[i+1]
                    let colors : [CGColor] = [fromColor.cgColor,toColor.cgColor]
                    let stopOne: CGFloat = 0.0
                    let stopTwo: CGFloat = 1.0
                    let locations : [CGFloat] = [stopOne,stopTwo]
                    graint.colors = colors
                    graint.locations = locations as [NSNumber]? // with Swift 2 and Swift 3 you can cast directly a `CGFloat` value to `NSNumber` and back
                    graint.startPoint = self.startPoints()[i]
                    graint.endPoint = self.endPoints()[i]
                    progressCircle.addSublayer(graint)
                    //Set mask
                    
                    let shapelayer = CAShapeLayer()
                    let rect = CGRect(origin:.zero,
                                      size:CGSize(width: bounds.width - 2 * lineWidth,height: self.bounds.height - 2 * lineWidth))
                    shapelayer.bounds = rect
                    shapelayer.position = CGPoint(x:bounds.width/2,y: bounds.height/2)
                    shapelayer.strokeColor = UIColor.blue.cgColor
                    shapelayer.fillColor = UIColor.clear.cgColor
                    shapelayer.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width/2).cgPath
                    shapelayer.lineWidth = lineWidth
                    shapelayer.lineCap = kCALineCapRound
                    shapelayer.strokeStart = 0.010
                    let finalValue = CGFloat(1.0*0.99)
                    shapelayer.strokeEnd = finalValue//0.99;
                    progressCircle.mask = shapelayer
                }
    }
    
    func animate(to progress: CGFloat, animated: Bool = true) {
        if animated {
            progressCircle.strokeEnd = progress
            
                        let circleMask = progressCircle.mask as! CAShapeLayer
                        circleMask.strokeEnd = progress
            
            
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
                
                                let circleMask = progressCircle.mask as! CAShapeLayer
                                circleMask.strokeEnd = progress
            }
        }
    }
    
        func startPoints() -> [CGPoint] {
            return [CGPoint.zero,CGPoint(x:1,y:0),CGPoint(x:1,y:1),CGPoint(x:0,y:1)]
        }
        
        func endPoints() -> [CGPoint] {
            return [CGPoint(x:1,y:1),CGPoint(x:0,y:1),CGPoint.zero,CGPoint(x:1,y:0)]
        }
        
        func graint(fromColor:UIColor, toColor:UIColor, count:Int) -> [UIColor]{
            var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
            fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)
            
            var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
            toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
            
            var result : [UIColor]! = [UIColor]()
            
            for i in 0...count {
                let oneR:CGFloat = fromR + (toR - fromR)/CGFloat(count) * CGFloat(i)
                let oneG : CGFloat = fromG + (toG - fromG)/CGFloat(count) * CGFloat(i)
                let oneB : CGFloat = fromB + (toB - fromB)/CGFloat(count) * CGFloat(i)
                let oneAlpha : CGFloat = fromAlpha + (toAlpha - fromAlpha)/CGFloat(count) * CGFloat(i)
                let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
                result.append(oneColor)
                print(oneColor)
                
            }
            return result
        }
        
        func positionArrayWith(bounds:CGRect) -> [CGPoint]{
            let first = CGPoint(x:(bounds.width/4)*3,y: (bounds.height/4)*1)
            let second = CGPoint(x:(bounds.width/4)*3,y: (bounds.height/4)*3)
            let third = CGPoint(x:(bounds.width/4)*1,y: (bounds.height/4)*3)
            let fourth = CGPoint(x:(bounds.width/4)*1,y: (bounds.height/4)*1)
            print([first,second,third,fourth])
            return [first,second,third,fourth]
        }
}









import UIKit

//@IBDesignable
class GradientView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    func update(withFrame newFrame: CGRect, startColor: UIColor, endColoer: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        
        frame = newFrame
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColoer.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
    
    func setup(withFrame newFrame: CGRect, startColor: UIColor, endColoer: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        
        frame = newFrame
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColoer.cgColor]
        //        gl.locations = [0.5, 0.45]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.addSublayer(gradientLayer)
    }
    
    //    func fillFully(view: UIView, startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
    //        translatesAutoresizingMaskIntoConstraints = false
    ////        let horisontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[item1]-(0)-|",
    ////                                                                   options: [], metrics: nil,
    ////                                                                   views: ["item1" : self])
    ////        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[item1]-(0)-|",
    ////                                                                 options: [], metrics: nil,
    ////                                                                 views: ["item1" : self])
    //    
    ////        view.addConstraints(horisontalConstraints + verticalConstraints)
    //        
    //        setup(withFrame: bounds, startColor: startColor, endColoer: endColor, startPoint: startPoint, endPoint: endPoint)
    //    }
}

//========
//+


class GradientLoadingIndicator: UIView {
    let circlePathLayer = CAShapeLayer()
    var circleRadius: CGFloat {
        return bounds.width / 2
    }
    let lineWidth: CGFloat = 14
    
    let gradientView = GradientView()
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    
    func resetProgress() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circlePathLayer.strokeEnd = 0
        CATransaction.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurate()
    }
    
    func configurate() {
        progress = 0
        circlePathLayer.frame = bounds
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.strokeColor = UIColor.red.cgColor
        layer.addSublayer(circlePathLayer)
        circlePathLayer.lineWidth = lineWidth
        addMaskGradient()
    }
    
    private func addMaskGradient() {
        gradientView.setup(withFrame: bounds, startColor: UIColor.red, endColoer: UIColor.blue, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        addSubview(gradientView)
        
        gradientView.layer.mask = circlePathLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().cgPath
        gradientView.update(withFrame: bounds, startColor: UIColor.red, endColoer: UIColor.blue, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
    }
    
    func circleFrame() -> CGRect {
        let circleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2),
                            radius: circleRadius - lineWidth / 2,
                            startAngle: -CGFloat.pi * 3 / 2,
                            endAngle: CGFloat.pi / 2, clockwise: true)
    }
}













final class WCGraintCircleLayer: CALayer {
    
    override init () {
        super.init()
    }
    
    convenience init(bounds:CGRect,position:CGPoint,fromColor:UIColor,toColor:UIColor,linewidth:CGFloat,toValue:CGFloat) {
        self.init()
        self.bounds = bounds
        self.position = position
        let colors : [UIColor] = self.graint(fromColor: fromColor, toColor:toColor, count:4)
        for i in 0..<colors.count-1 {
            let graint = CAGradientLayer()
            graint.bounds = CGRect(origin:CGPoint.zero, size: CGSize(width:bounds.width/2,height:bounds.height/2))
            let valuePoint = self.positionArrayWith(bounds: self.bounds)[i]
            graint.position = valuePoint
            print("iesimo graint position: \(graint.position)")
            let fromColor = colors[i]
            let toColor = colors[i+1]
            let colors : [CGColor] = [fromColor.cgColor,toColor.cgColor]
            let stopOne: CGFloat = 0.0
            let stopTwo: CGFloat = 1.0
            let locations : [CGFloat] = [stopOne,stopTwo]
            graint.colors = colors
            graint.locations = locations as [NSNumber]? // with Swift 2 and Swift 3 you can cast directly a `CGFloat` value to `NSNumber` and back
            graint.startPoint = self.startPoints()[i]
            graint.endPoint = self.endPoints()[i]
            self.addSublayer(graint)
            //Set mask
            let shapelayer = CAShapeLayer()
            let rect = CGRect(origin:CGPoint.zero,size:CGSize(width:self.bounds.width - 2 * linewidth,height: self.bounds.height - 2 * linewidth))
            shapelayer.bounds = rect
            shapelayer.position = CGPoint(x:self.bounds.width/2,y: self.bounds.height/2)
            shapelayer.strokeColor = UIColor.blue.cgColor
            shapelayer.fillColor = UIColor.clear.cgColor
            shapelayer.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width/2).cgPath
            shapelayer.lineWidth = linewidth
            shapelayer.lineCap = kCALineCapRound
            shapelayer.strokeStart = 0.010
            let finalValue = (toValue*0.99)
            shapelayer.strokeEnd = finalValue//0.99;
            self.mask = shapelayer
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layerWithWithBounds(bounds:CGRect, position:CGPoint, fromColor:UIColor, toColor:UIColor, linewidth : CGFloat,toValue:CGFloat) -> WCGraintCircleLayer {
        let layer = WCGraintCircleLayer(bounds: bounds,position: position,fromColor:fromColor, toColor: toColor,linewidth: linewidth,toValue:toValue )
        return layer
    }
    
    func graint(fromColor:UIColor, toColor:UIColor, count:Int) -> [UIColor]{
        var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
        fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)
        
        var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
        toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
        
        var result : [UIColor]! = [UIColor]()
        
        for i in 0...count {
            let oneR:CGFloat = fromR + (toR - fromR)/CGFloat(count) * CGFloat(i)
            let oneG : CGFloat = fromG + (toG - fromG)/CGFloat(count) * CGFloat(i)
            let oneB : CGFloat = fromB + (toB - fromB)/CGFloat(count) * CGFloat(i)
            let oneAlpha : CGFloat = fromAlpha + (toAlpha - fromAlpha)/CGFloat(count) * CGFloat(i)
            let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
            result.append(oneColor)
            print(oneColor)
            
        }
        return result
    }
    
    func positionArrayWith(bounds:CGRect) -> [CGPoint]{
        let first = CGPoint(x:(bounds.width/4)*3,y: (bounds.height/4)*1)
        let second = CGPoint(x:(bounds.width/4)*3,y: (bounds.height/4)*3)
        let third = CGPoint(x:(bounds.width/4)*1,y: (bounds.height/4)*3)
        let fourth = CGPoint(x:(bounds.width/4)*1,y: (bounds.height/4)*1)
        print([first,second,third,fourth])
        return [first,second,third,fourth]
    }
    
    func startPoints() -> [CGPoint] {
        return [CGPoint.zero,CGPoint(x:1,y:0),CGPoint(x:1,y:1),CGPoint(x:0,y:1)]
    }
    
    func endPoints() -> [CGPoint] {
        return [CGPoint(x:1,y:1),CGPoint(x:0,y:1),CGPoint.zero,CGPoint(x:1,y:0)]
    }
    
    func midColorWithFromColor(fromColor:UIColor, toColor:UIColor, progress:CGFloat) -> UIColor {
        var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
        fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)
        
        var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
        toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
        
        let oneR = fromR + (toR - fromR) * progress
        let oneG = fromG + (toG - fromG) * progress
        let oneB = fromB + (toB - fromB) * progress
        let oneAlpha = fromAlpha + (toAlpha - fromAlpha) * progress
        let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
        return oneColor
    }
    
    // This is what you call if you want to draw a full circle.
    func animateCircle(duration: TimeInterval) {
        animateCircleTo(duration: duration, fromValue: 0.010, toValue: 0.99)
    }
    
    // This is what you call to draw a partial circle.
    func animateCircleTo(duration: TimeInterval, fromValue: CGFloat, toValue: CGFloat){
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.isRemovedOnCompletion = true
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0.010 (no circle) to 0.99 (full circle)
        animation.fromValue = 0.010
        animation.toValue = toValue
        
        // Do an easeout. Don't know how to do a spring instead
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // Set the circleLayer's strokeEnd property to 0.99 now so that it's the
        // right value when the animation ends.
        let circleMask = self.mask as! CAShapeLayer
        circleMask.strokeEnd = toValue
        
        // Do the actual animation
        circleMask.removeAllAnimations()
        circleMask.add(animation, forKey: "animateCircle")
    }
}
