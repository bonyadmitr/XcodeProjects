//
//  CodeDetector.swift
//  QRScanner
//
//  Created by Bondar Yaroslav on 27/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import ZXingObjC

final class CodeDetector {
    
    static let shared = CodeDetector()
    
    /// native
    // TODO: add func with VNDetectBarcodesRequest https://stackoverflow.com/a/57542177/5893286
    func readQR(from image: UIImage) -> String? {
        if let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                     context: nil,
                                     options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
            let ciImage = CIImage(image: image),
            let features = detector.features(in: ciImage) as? [CIQRCodeFeature]
        {
            return features.first?.messageString
        } else {
            assertionFailure("nil in simulator, A7 core +")
            return nil
        }
    }
    
    func readAnyCode(from image: UIImage) -> String? {
        ///check ZXCaptureDelegate
        let luminanceSource = ZXCGImageLuminanceSource(cgImage: image.cgImage)
        let binarizer = ZXHybridBinarizer(source: luminanceSource)
        let bitmap = ZXBinaryBitmap(binarizer: binarizer)
        let hints = ZXDecodeHints.hints() as! ZXDecodeHints
        let QRReader = ZXMultiFormatReader()
        
        do {
            let result = try QRReader.decode(bitmap, hints: hints)
            return result.text
        } catch {
            return nil
        }
    }
}
