//
//  CodeGenerator.swift
//  QRScanner
//
//  Created by Bondar Yaroslav on 27/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// can be used ZXingObjC
/// test for limits
final class CodeGenerator {
    
    static let shared = CodeGenerator()
    
    /**
     The level of error correction.
     
     - Low:      7%
     - Medium:   15%
     - Quartile: 25%
     - High:     30%
     */
    //    public enum ErrorCorrection: String {
    //        case Low = "L"
    //        case Medium = "M"
    //        case Quartile = "Q"
    //        case High = "H"
    //    }
    
    /// https://github.com/aschuch/QRCode/blob/master/QRCode/QRCode.swift
    /// with improvements https://stackoverflow.com/a/43341528
    
    // TODO: remove "!"
    func convertTextToQRCode(text: String, size: CGSize) -> UIImage {
        
        let data = text.data(using: .isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        
        //filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("L", forKey: "inputCorrectionLevel")
        
        // Color code and background
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return UIImage() }
        //colorFilter.setDefaults()
        colorFilter.setValue(filter.outputImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(color: UIColor.red), forKey: "inputColor0")
        colorFilter.setValue(CIColor(color: UIColor.blue), forKey: "inputColor1")
        
        
        
        let qrcodeCIImage = colorFilter.outputImage!
        
        let cgImage = CIContext().createCGImage(qrcodeCIImage, from: qrcodeCIImage.extent)!
        
        let scale = UIScreen.main.scale
        let newSize = CGSize(width: size.width * scale, height:size.height * scale)
        
        UIGraphicsBeginImageContext(newSize)
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .none
        
        context.draw(cgImage, in: CGRect(x: 0.0,y: 0.0,width: context.boundingBoxOfClipPath.width,height: context.boundingBoxOfClipPath.height))
        
        let preImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return UIImage(cgImage: preImage.cgImage!, scale: 1.0/scale, orientation: .downMirrored)
    }
    
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
