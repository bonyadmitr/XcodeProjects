// The MIT License (MIT)
//
// Copyright (c) 2015 Meng To (meng@designcode.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

@IBDesignable public class DesignableButton: UIButton {

    
    @IBInspectable public var imageVertical: Bool = false {
        didSet {
            updateImages()
        }
    }
    
    @IBInspectable public var imageYSpace: CGFloat = 10 {
        didSet {
            updateImages()
        }
    }
    
    @IBInspectable public var imageXSpace: CGFloat = 0 {
        didSet {
            updateImages()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    
    func updateImages() {
        if imageVertical {
            var frame = imageView!.frame
            frame = CGRectMake((bounds.size.width - frame.size.width) / 2,
                               frame.y - imageYSpace,
                               frame.size.width,
                               frame.size.height)
            imageView!.frame = frame
            
            frame = titleLabel!.frame;
            frame = CGRectMake((bounds.size.width - frame.size.width) / 2,
                               frame.y + imageYSpace,
                               frame.size.width,
                               frame.size.height)
            
            titleLabel!.frame = frame
            
        } else {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageXSpace)
            titleEdgeInsets = UIEdgeInsetsMake(0, imageXSpace, 0, 0)
        }
    }


}

class BYButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = UIColor.redColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.redColor()
        setBackgroundColor(UIColor.whiteColor(), forState: .Highlighted)
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        //layer.masksToBounds = true
        //cornerRadius = 10
        //borderWidth = 3
        //borderColor = UIColor.redColor()
        tintColor = UIColor.yellowColor()
        //backgroundColor = UIColor.whiteColor()
        //backgroundColor = UIColor.redColor()
        //addBorder(width: 10, color: UIColor.blueColor())
        //setCornerRadius(radius: 10)
        layer.cornerRadius = 15
        layer.borderWidth = 5
        layer.masksToBounds = true
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        backgroundColor = UIColor.redColor()
        
    }
}

//extension String {
    //func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        //let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        //let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        //return boundingBox.height
    //}
//}







