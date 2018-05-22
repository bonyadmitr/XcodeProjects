//
//  UIImage+HEIC.swift
//  ImageFormat
//
//  Created by Bondar Yaroslav on 2/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
    
    /// https://github.com/filestack/filestack-ios/blob/master/Filestack/Extensions/UIImage%2BHEIC.swift
    @available(iOS 11.0, *)
    func heicRepresentation(quality: Float) -> Data? {
        let destinationData = NSMutableData()
        
        if let destination = CGImageDestinationCreateWithData(destinationData, AVFileType.heic as CFString, 1, nil),
            let cgImage = cgImage
        {
            let options = [kCGImageDestinationLossyCompressionQuality: quality]
            CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)
            CGImageDestinationFinalize(destination)
            
            return destinationData as Data
        }
        
        return nil
    }
}
