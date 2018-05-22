//
//  UIImage+Image.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 02/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIImage {
    func cropped(to rect: CGRect) -> UIImage {
        guard
            rect.size.height < size.height,
            rect.size.height < size.height,
            let image: CGImage = cgImage?.cropping(to: rect)
            else { return self }
        return UIImage(cgImage: image)
    }
    
    
    
    private var isPortrait: Bool    {
        return size.height > size.width
    }
    private var isLandscape: Bool {
        return size.width > size.height
    }
    private var breadth: CGFloat {
        return min(size.width, size.height)
    }
    private var breadthSize: CGSize {
        return CGSize(width: breadth, height: breadth)
    }
    private var breadthRect: CGRect {
        return CGRect(origin: .zero, size: breadthSize)
    }
    
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        let q = CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0,
                        y: isPortrait  ? floor((size.height - size.width) / 2) : 0)
        let rect = CGRect(origin: q, size: breadthSize)
        guard let cgImage = cgImage?.cropping(to: rect) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
