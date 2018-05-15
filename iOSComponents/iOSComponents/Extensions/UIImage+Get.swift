//
//  UIImage+New.swift
//  SwiftBest
//
//  Created by zdaecqze zdaecq on 25.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizedImageAspectRatioWithNewWidth(newWidth: CGFloat) -> UIImage {
        let newSize = self.size.aspectRatioForWidth(newWidth)
        return resizedImageWithSize(newSize)
    }
    
    func resizedImageWithSize(newSize: CGSize) -> UIImage {
        let newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage: UIImage!
        
        let scale = UIScreen.mainScreen().scale
        
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0);
        newImage = UIImage(CGImage: self.CGImage!, scale: scale, orientation: self.imageOrientation)
        newImage.drawInRect(newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        let data = UIImageJPEGRepresentation(newImage, 0.9)
        let newI = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
        
        return newI!
    }
    
    /// EZSE: scales image
    public class func scaleTo(image image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// EZSE Returns resized image with width. Might return low quality
    public func resizeWithWidth(width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))
        
        UIGraphicsBeginImageContext(aspectSize)
        self.drawInRect(CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    /// EZSE Returns resized image with height. Might return low quality
    public func resizeWithHeight(height: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)
        
        UIGraphicsBeginImageContext(aspectSize)
        self.drawInRect(CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    /// EZSE: Returns cropped image from CGRect
    public func croppedImage(bound: CGRect) -> UIImage? {
        guard self.size.width > bound.origin.x else {
            print("EZSE: Your cropping X coordinate is larger than the image width")
            return nil
        }
        guard self.size.height > bound.origin.y else {
            print("EZSE: Your cropping Y coordinate is larger than the image height")
            return nil
        }
        let scaledBounds: CGRect = CGRect(x: bound.x * self.scale, y: bound.y * self.scale, width: bound.w * self.scale, height: bound.h * self.scale)
        let imageRef = CGImageCreateWithImageInRect(self.CGImage!, scaledBounds)
        let croppedImage: UIImage = UIImage(CGImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.Up)
        return croppedImage
    }
}
