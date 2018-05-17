//
//  LockView.swift
//  LockPattern
//
//  Created by Yaroslav Bondar on 14.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import UIKit

protocol LockViewDelegate : class {
    func didEndTouchWithPathArray(pathArray: [Int])
    func createBasePointLayer() -> CALayer
    func createSelectionPointLayer() -> CALayer
}


class LockView: UIView {

    // MARK: - Public properties
    var lockSize = CGSize(width: 60, height: 60)
    
    var lockNumberX : Int = 3
    var lockNumberY : Int = 3
    
    var lineWidth : CGFloat = 3
    var lineColor : UIColor = UIColor.redColor()
    
    var resetManual : Bool = false
    
    weak var delegate : LockViewDelegate?

    
    // MARK: - Private properties
    private var stepLengthX : CGFloat = 0
    private var stepLengthY : CGFloat = 0
    private var locksPathArray : [Int] = []
    
    private var baseLayer       : CALayer!
    private var lineLayer       : CAShapeLayer!
    private var selectionLayer  = CALayer()
    
    private var editable : Bool = true
    
    
    // MARK: - Life cycle
    //override init(frame: CGRect) {
        //super.init(frame: frame)
        ////setup()
    //}
    
    //required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        ////setup()
    //}
    
    //override var bounds: CGRect {
        //get {
            //return super.bounds
        //}
        //set {
            //super.bounds = newValue
            //if let lineLayer = lineLayer {
                //lineLayer.removeFromSuperlayer()
                //baseLayer.removeFromSuperlayer()
                //selectionLayer.removeFromSuperlayer()
            //}
            //setup()
        //}

    //}
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        setup()
    }
    
    private func setup() {

        stepLengthX = (bounds.width - lockSize.width) / CGFloat(lockNumberX - 1)
        stepLengthY = (bounds.height - lockSize.height) / CGFloat(lockNumberY - 1)
        
        baseLayer = createBaseLayer()
        lineLayer = createLineLayer()
        
        layer.addSublayer(lineLayer)
        layer.addSublayer(baseLayer)
        layer.addSublayer(selectionLayer)
    }

    
    // MARK: - Private draw methods
    private func createBaseLayer() -> CALayer {
        
        let layer = CALayer()

        var origin = CGPoint(x: lockSize.width / 2, y: lockSize.height / 2)
        
        for _ in 0..<lockNumberY {
            for _ in 0..<lockNumberX {
                
                guard let delegate = delegate else {
                    print("need to confirm to LockViewDelegate")
                    return CALayer()
                }
                
                let baseSubLayer = delegate.createBasePointLayer()
                baseSubLayer.position = origin
                layer.addSublayer(baseSubLayer)
                origin.x += stepLengthX
                
            }
            origin.x = lockSize.width / 2
            origin.y += stepLengthY
        }
        
        return layer
    }
    
    
    private func createLineLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineCap = "round"
        layer.lineJoin = "round"
        layer.lineWidth = lineWidth
        layer.strokeColor = lineColor.CGColor
        layer.fillColor = nil
        return layer
    }
    
    //    func createBasePointLayer() -> CALayer {
    //
    //        let origin = CGPoint(x: -lockView.lockSize.width/2, y: -lockView.lockSize.height/2)
    //        let path = UIBezierPath(ovalInRect: CGRect(origin: origin, size: lockView.lockSize))
    //
    //        let layer = CAShapeLayer()
    //        layer.path = path.CGPath
    //        layer.fillColor = UIColor.blackColor().CGColor
    //        return layer
    //    }
    //
    //    func createSelectionPointLayer() -> CALayer {
    //
    //        let halfSize = CGSize(width: lockView.lockSize.width / 2, height: lockView.lockSize.height / 2)
    //        let origin = CGPoint(x: -halfSize.width/2, y: -halfSize.height/2)
    //        let path = UIBezierPath(ovalInRect: CGRect(origin: origin, size: halfSize))
    //
    //        let layer = CAShapeLayer()
    //        layer.path = path.CGPath
    //        layer.fillColor = UIColor.yellowColor().CGColor
    //
    //        return layer
    //    }
    
    
    // MARK: - Private methods
    private func getLockIndexForPoint(point: CGPoint) -> Int? {
        
        let xi : Int? = (point.x % stepLengthX) < lockSize.width ? Int(point.x / stepLengthX) : nil
        let yi : Int? = (point.y % stepLengthY) < lockSize.height ? Int(point.y / stepLengthY) : nil
        
        if let xi = xi, let yi = yi {
            return xi + yi * lockNumberX
        }
        
        return nil
    }
    
    
    private func getPointForLockIndex(index: Int) -> CGPoint {
        let x = index % lockNumberX
        let y = index / lockNumberX
        
        let point = CGPoint(x: CGFloat(x) * stepLengthX + lockSize.width / 2, y: CGFloat(y) * stepLengthY + lockSize.height / 2)
        return point
    }
    
    
    private func getLinePathWithLockArray() -> UIBezierPath {
        
        if locksPathArray.count == 0 {
            return UIBezierPath()
        }
        
        var pointsArray : [CGPoint] = []
        
        for index in locksPathArray {
            
            let point = getPointForLockIndex(index)
            pointsArray.append(point)
        }
        
        let path = UIBezierPath()
        path.moveToPoint(pointsArray.first!)
        pointsArray.removeFirst()
        
        for point in pointsArray {
            path.addLineToPoint(point)
        }
        
        return path
    }
    
    
    private func getPathWithFinalPoint(finalPoint: CGPoint) -> UIBezierPath {
        
        let path = getLinePathWithLockArray()
        if path == UIBezierPath() {
            return path
        }
        
        path.addLineToPoint(finalPoint)
        return path
    }
    
    
    // MARK: - Public methods
    func reset() {
        
        editable = true
        
        locksPathArray.removeAll()
        
        let path = getLinePathWithLockArray()
        lineLayer.path = path.CGPath

        if let sublayers = selectionLayer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
    }
    

    // MARK: - Touches events
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard let delegate = delegate else {
            print("Error: Need to confirm protocol LockViewDelegate")
            return
        }
        
        if editable == false {
            return
        }
        
        let touch = touches.first
        let point = touch!.locationInView(self)
        
        if pointInside(point, withEvent: nil) {
            
            if let index = getLockIndexForPoint(point) {
                
                if !locksPathArray.contains(index) {
                    
                    locksPathArray.append(index)
                    let pointOfLockIndex = getPointForLockIndex(index)
                    
                    let selectionSublayerLayer = delegate.createSelectionPointLayer()
                    selectionSublayerLayer.position = pointOfLockIndex
                    selectionLayer.addSublayer(selectionSublayerLayer)
                }
            }
        }
        
        let path = getPathWithFinalPoint(point)
        
        lineLayer.path = path.CGPath
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if editable == false {
            return
        }
        
        if let delegate = delegate {
            delegate.didEndTouchWithPathArray(locksPathArray)
        }
        
        if resetManual {
            editable = false
            let path = getLinePathWithLockArray()
            lineLayer.path = path.CGPath
        } else {
            reset()
        }
        
    }
    
}








