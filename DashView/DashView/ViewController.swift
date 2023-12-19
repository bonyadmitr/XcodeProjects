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
