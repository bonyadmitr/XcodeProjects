//
//  ViewController.swift
//  OCRManager
//
//  Created by Bondar Yaroslav on 4/15/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let documentScanner = DocumentScanner()
    
    let cameraManager = CameraManager()
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("- started")
        
        cameraManager.prepare()
        cameraManager.showCameraFeed(in: view)
        
        cameraManager.imageBufferHandler = { imageBuffer in
            OCRManager().scanFast(imageBuffer: imageBuffer) {  ocrText in
                DispatchQueue.main.async {
                    self.label.text = ocrText
                }
                
                print(ocrText)
                print("--------------------")
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
}

import AVFoundation

final class CameraManager: NSObject {
    
    private let captureSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    var imageBufferHandler: ( (CVImageBuffer) -> Void )?
    
    func appear() {
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.startRunning()
    }
    
    func disappear() {
        self.videoDataOutput.setSampleBufferDelegate(nil, queue: nil)
        self.captureSession.stopRunning()

    }
    
    func prepare() {
        setCameraInput()
        setCameraOutput()
    }
    
    private func setCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .back).devices.first else {
                fatalError("No back camera device found.")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    func showCameraFeed(in view: UIView) {
        self.previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = view.frame
    }
    
    func updateFrame(with rect: CGRect) {
        self.previewLayer.frame = rect
    }
    
    private func setCameraOutput() {
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
            connection.isVideoOrientationSupported else { return }
        
        connection.videoOrientation = .portrait
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        
        imageBufferHandler?(imageBuffer)
    }

}
