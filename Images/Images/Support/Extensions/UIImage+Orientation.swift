//
//  UIImage+Orientation.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 11/10/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import UIKit

/// with optimization from https://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
extension UIImage {
    
    var imageWithFixedOrientation: UIImage {
        
        /// No-op if the orientation is already correct
        if imageOrientation == .up {
            return self
        }
        
        /// We need to calculate the proper transformation to make the image upright.
        /// We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height);
            transform = transform.rotated(by: -.pi / 2.0);
        case .up, .upMirrored:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        default:
            break
        }
        
        /// Now we draw the underlying CGImage into a new context, applying the transform calculated above.
        
        guard let cgImage = cgImage,
            let colorSpace = cgImage.colorSpace,
            let ctx = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: cgImage.bitsPerComponent,
                                bytesPerRow: 0,
                                space: colorSpace,
                                bitmapInfo: cgImage.bitmapInfo.rawValue)
            else { return self }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        /// And now we just create a new UIImage from the drawing context and return it
        guard let newCGImage = ctx.makeImage() else {
            return self
        }
        return UIImage(cgImage: newCGImage)
    }
}
