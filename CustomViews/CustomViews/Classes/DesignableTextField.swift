import UIKit

@IBDesignable class DesignableTextField: UITextField {

    @IBInspectable var image: UIImage? {
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
    
    @IBInspectable var imageSize: CGSize = CGSize() {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
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
            layer.masksToBounds = true
        }
    }

    @IBInspectable var underline: Bool = false {
        didSet {
            updateUndeline()
        }
    }
    @IBInspectable var underlineColor: UIColor = UIColor.white {
        didSet {
            updateUndeline()
        }
    }
    @IBInspectable var underlineWidth: CGFloat = 1 {
        didSet {
            updateUndeline()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.clear {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
            layoutSubviews()
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func updateUndeline() {
        if underline {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: frame.size.height - underlineWidth, width: frame.size.width, height: underlineWidth);
            bottomBorder.backgroundColor = underlineColor.cgColor
            layer.addSublayer(bottomBorder)
        }
    }
    
    func updateImage() {
        guard let image = image else { return }
            
        let imageView = UIImageView(image: image)
        
        if imageSize == CGSize() {
            imageView.frame = CGRect(origin: CGPoint(), size: CGSize(width: bounds.height, height: bounds.height))
        } else {
            imageView.frame = CGRect(origin: CGPoint(), size: imageSize)
        }
        
        if imageLeftPadding != 0 || imageRigthPadding != 0 {
            imageView.frame.origin.x = imageLeftPadding
            let viewWidth = imageLeftPadding + imageView.frame.width + imageRigthPadding
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: imageView.frame.height))
            padding.addSubview(imageView)
            
            leftView = padding
        } else {
            leftView = imageView;
        }
        
        leftViewMode = .always
    }

    
}

