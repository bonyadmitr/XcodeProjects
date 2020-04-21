//
//  ViewController.swift
//  OCRManager
//
//  Created by Bondar Yaroslav on 4/15/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

import Vision


extension CGImage {
    
    /// inspired https://stackoverflow.com/a/45815004/5893286
    static func fromCIImage(_ ciImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
}

import AVFoundation

/// https://stackoverflow.com/q/49302828/5893286
func getImageFromSampleBuffer(buffer: CMSampleBuffer, orientation: UIImage.Orientation) -> UIImage? {
    if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))

        if let image = context.createCGImage(ciImage, from: imageRect) {
            return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: orientation)

        }

    }
    return nil
}

class ViewController: UIViewController {

    let documentScanner = DocumentScanner()
    
    let cameraManager = CameraManager()
    
    let label = UILabel()
    
    private var maskLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("- started")
        
        cameraManager.prepare()
        cameraManager.showCameraFeed(in: view)
        
        cameraManager.imageBufferHandler = { imageBuffer in
//            OCRManager().scanFast(imageBuffer: imageBuffer) {  ocrText in
//                DispatchQueue.main.async {
//                    self.label.text = ocrText
//                }
//
//                print(ocrText)
//                print("--------------------")
//            }
            
            
                    
                    OCRManager().detectRectangle(in: imageBuffer) { rectangle in
                        DispatchQueue.main.async {
                            self.removeMask()
                            guard let rectangle = rectangle else {
                                return
                            }
                            
                            self.drawBoundingBox(rect: rectangle)
            //
            //                    if self.isTapped{
            //                        self.isTapped = false
            //                        self.doPerspectiveCorrection(rect, from: image)
            //                    }

                        }
                        
                    }
            
        }
        
        view.addSubview(label)
        label.numberOfLines = 0
        label.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cameraManager.appear()
        
//        documentScanner.open(in: self) { images in
//            for image in images {
//                OCRManager().scan(image: image) { ocrText in
//                    print(ocrText)
//                }
//            }
//        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cameraManager.disappear()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cameraManager.updateFrame(with: view.frame)
    }
    
    /// article https://heartbeat.fritz.ai/scanning-credit-cards-with-computer-vision-on-ios-c3f4d8912de4
    func drawBoundingBox(rect : VNRectangleObservation) {
    
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -cameraManager.previewLayer.frame.height)
        let scale = CGAffineTransform.identity.scaledBy(x: cameraManager.previewLayer.frame.width, y: cameraManager.previewLayer.frame.height)

        let bounds = rect.boundingBox.applying(scale).applying(transform)
        createLayer(in: bounds)

    }

    private func createLayer(in rect: CGRect) {

        maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.cornerRadius = 10
        maskLayer.opacity = 0.75
        maskLayer.borderColor = UIColor.red.cgColor
        maskLayer.borderWidth = 5.0
        
        cameraManager.previewLayer.insertSublayer(maskLayer, at: 1)

    }
    
    func removeMask() {
            maskLayer.removeFromSuperlayer()

    }
}
