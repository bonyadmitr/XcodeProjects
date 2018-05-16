
import UIKit

private var xoAssociationKey: UInt8 = 0

protocol foo: class {
    var underline       : Bool      {get set}
    var underlineColor  : UIColor   {get set}
    var underlineWidth  : CGFloat   {get set}
    
    func updateUndeLine()
}

extension foo where Self: UIView {
    
    var underline : Bool {
        
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as! Bool
        }
        set {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            updateUndeLine()
        }
    }
    
    var underlineColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as! UIColor
        }
        set {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            updateUndeLine()
        }
    }
    
    var underlineWidth: CGFloat {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as! CGFloat
        }
        set {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            updateUndeLine()
        }
    }
    
    func updateUndeLine() {
        if underline {
            let underline = CAShapeLayer()
            let bezierPath = UIBezierPath()
            bezierPath.moveToPoint(CGPointMake(0, bounds.height - underlineWidth / 2))
            bezierPath.addLineToPoint(CGPointMake(bounds.width, bounds.height - underlineWidth / 2))
            underline.path = bezierPath.CGPath
            underline.strokeColor = underlineColor.CGColor
            underline.lineWidth = underlineWidth
            layer.addSublayer(underline)
            
            //let bottomBorder = CALayer()
            //bottomBorder.frame = CGRectMake(0.0, frame.size.height - underlineWidth, frame.size.width, underlineWidth);
            //bottomBorder.backgroundColor = underlineColor.CGColor
            //layer.addSublayer(bottomBorder)
        }
    }
}



@IBDesignable class DesignableTextField: UITextField {

    @IBInspectable var image : UIImage? {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable var imageLeftPadding: CGFloat = 0 {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable var imageRigthPadding: CGFloat = 0 {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable var imageSize: CGSize = CGSizeZero {
        didSet {
            updateImage()
        }
    }



    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var underline: Bool = false {
        didSet {
            updateUndeLine()
        }
    }
    @IBInspectable var underlineColor: UIColor = UIColor.whiteColor() {
        didSet {
            updateUndeLine()
        }
    }
    @IBInspectable var underlineWidth: CGFloat = 1 {
        didSet {
            updateUndeLine()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.clearColor() {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSForegroundColorAttributeName: placeholderColor])
            layoutSubviews()
            
        }
    }
    
    override func drawRect(rect: CGRect) {
        
    }
    
    func updateUndeLine() {
        if underline {
            let underline = CAShapeLayer()
            let bezierPath = UIBezierPath()
            bezierPath.moveToPoint(CGPointMake(0, bounds.height - underlineWidth / 2))
            bezierPath.addLineToPoint(CGPointMake(bounds.width, bounds.height - underlineWidth / 2))
            underline.path = bezierPath.CGPath
            underline.strokeColor = underlineColor.CGColor
            underline.lineWidth = underlineWidth
            layer.addSublayer(underline)
            
            //let bottomBorder = CALayer()
            //bottomBorder.frame = CGRectMake(0.0, frame.size.height - underlineWidth, frame.size.width, underlineWidth);
            //bottomBorder.backgroundColor = underlineColor.CGColor
            //layer.addSublayer(bottomBorder)
        }
    }
    
    func updateImage() {
        if let image = image {
            
            let imageView = UIImageView()
            imageView.image = image
            
            if imageSize == CGSizeZero {
                imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: bounds.height, height: bounds.height))
            } else {
                imageView.frame = CGRect(origin: CGPointZero, size: imageSize)
            }
            
            if imageLeftPadding != 0 || imageRigthPadding != 0 {
                imageView.frame.x = imageLeftPadding
                let viewWidth = imageLeftPadding + imageView.frame.width + imageRigthPadding
                let padding = UIView(frame: CGRectMake(0, 0, viewWidth, imageView.frame.height))
                padding.addSubview(imageView)
                
                leftView = padding
            } else {
                leftView = imageView;
            }
            
            leftViewMode = .Always
        }
    }

    
}

