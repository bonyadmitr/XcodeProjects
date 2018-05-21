//
//  UIImage+Init.swift
//  SwiftBest
//
//  Created by zdaecqze zdaecq on 25.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIImage {
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    ///EZSE: Returns the image associated with the URL
    public convenience init?(urlString: String) {
        guard let url = NSURL(string: urlString) else {
            self.init(data: NSData())
            return
        }
        guard let data = NSData(contentsOfURL: url) else {
            print("EZSE: No image in URL \(urlString)")
            self.init(data: NSData())
            return
        }
        self.init(data: data)
    }
    
    convenience init?(named: String, tintColor: UIColor) {
        if let image = UIImage(named: named)?.withColor(tintColor) {
            self.init(CGImage: image.CGImage!)
        } else {
            return nil
        }
    }
    
    convenience init(color: UIColor) {
        self.init(color: color, size: CGSizeMake(1, 1))
    }
    
    convenience init(color: UIColor, size: CGSize) {
        
        var rect = CGRectZero
        rect.size = size
        
        UIGraphicsBeginImageContext(size);
        let path = UIBezierPath(rect: rect)
        color.setFill()
        path.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.init(CGImage: image!.CGImage!)
        
    }
    
    convenience init(image: UIImage, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.init(CGImage: newImage!.CGImage!)
    }
    
    ///EZSE: Returns an empty image
    public class func blankImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
