//
//  CodeCameraScanner.swift
//  QRScanner
//
//  Created by Bondar Yaroslav on 27/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import AVFoundation

protocol CodeCameraScannerDelegate: class {
    func codeCameraScanner(_ scanner: CodeCameraScanner, didDetect text: String)
}

final class CodeCameraScanner: NSObject {
    
    private var captureSession: AVCaptureSession!
    
    weak var delegate: CodeCameraScannerDelegate?
    
    private let supportedCodeTypes: [AVMetadataObject.ObjectType] = [.upce,
                                                                     .code39,
                                                                     .code39Mod43,
                                                                     .code93,
                                                                     .code128,
                                                                     .ean8,
                                                                     .ean13,
                                                                     .aztec,
                                                                     .pdf417,
                                                                     .qr]
    
    func prepareVideoPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        guard let captureDevice = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: captureDevice)
            else { return nil }
        
        captureSession = AVCaptureSession()
        captureSession.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        return videoPreviewLayer
    }
    
    func start() {
        captureSession?.startRunning()
    }
    
    func stop() {
        captureSession?.stopRunning()
    }
}

extension CodeCameraScanner: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard
            !metadataObjects.isEmpty,
            let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            supportedCodeTypes.contains(metadata.type),
            let text = metadata.stringValue
            else {
                return
        }
        
        delegate?.codeCameraScanner(self, didDetect: text)
    }
}
