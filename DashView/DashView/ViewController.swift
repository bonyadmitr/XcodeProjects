//
//  ViewController.swift
//  DashView
//
//  Created by Yaroslav Bondar on 07.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var dashView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        dashView.layer.cornerRadius = 30
//        dashView.backgroundColor = .blue
    }



}

//final class DashView: UIView {
//    private let shapeLayer: CAShapeLayer = {
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.lineWidth = 1.0
//        shapeLayer.lineDashPattern = [15, 5]
//        shapeLayer.strokeColor = UIColor.red.cgColor
//        shapeLayer.fillColor = nil //UIColor.clear.cgColor
//        return shapeLayer
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    private func setup() {
//        layer.addSublayer(shapeLayer)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        shapeLayer.path = CGPath(rect: bounds, transform: nil)
//        shapeLayer.frame = bounds
//    }
//
//}

/// draw + setLineDash https://stackoverflow.com/a/40512209/5893286
final class DashView: UIView {
    
    override class var layerClass: AnyClass { CAShapeLayer.self }
    private var shapeLayer: CAShapeLayer { layer as! CAShapeLayer }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        shapeLayer.lineWidth = 1.0
        shapeLayer.lineDashPattern = [15, 5]
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //shapeLayer.path = CGPath(rect: bounds, transform: nil)
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
}

/// dash animation https://stackoverflow.com/a/42722478/5893286 + in RunLoop project
