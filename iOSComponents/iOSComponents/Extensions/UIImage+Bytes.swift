//
//  UIImage+Bytes.swift
//  FFNN
//
//  Created by Bondar Yaroslav on 23/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

fileprivate struct PixelData {
    let a: UInt8
    let r: UInt8
    let g: UInt8
    let b: UInt8
}

extension UIImage {
    
    convenience init? (width: Int, height: Int, bytes: [UInt8]) {
        
        let pixels = bytes.map { PixelData(a: $0, r: 0, g: 0, b: 0) }
        
        //        let date = Data.init(bytes: bytes) /// not working
        let date = NSData(bytes: pixels, length: bytes.count * MemoryLayout<PixelData>.size)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        guard
            let providerRef = CGDataProvider(data: date as CFData),
            let cgim = CGImage(width: width,
                               height: height,
                               bitsPerComponent: 8,
                               bitsPerPixel: 32,
                               bytesPerRow: 28 * MemoryLayout<PixelData>.size,
                               space: rgbColorSpace,
                               bitmapInfo: bitmapInfo,
                               provider: providerRef,
                               decode: nil,
                               shouldInterpolate: true,
                               intent: .defaultIntent)
            else { return nil }
        
        self.init(cgImage: cgim)
    }
    
//    convenience init?(size: CGSize, bytes: [UInt8]) {
//        self.init(width: Int(size.width), height: Int(size.height), bytes: bytes)
//    }
}
