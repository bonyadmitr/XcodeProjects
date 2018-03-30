//
//  CameraManager.swift
//  CameraManager
//
//  Created by Bondar Yaroslav on 05/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import AVFoundation

/// http://www.appcoda.com/avfoundation-swift-guide/
/// https://github.com/imaginary-cloud/CameraManager
final class CameraManager {
    
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    enum CameraPosition {
        case front
        case rear
    }
    
    private lazy var captureSession = AVCaptureSession()
    
    private let stillImageOutput = AVCaptureStillImageOutput()
    
    private var frontCamera: AVCaptureDevice?
    private var rearCamera: AVCaptureDevice?
    
    private var currentCameraPosition: CameraPosition = .rear
    
    private var frontCameraInput: AVCaptureDeviceInput?
    private var rearCameraInput: AVCaptureDeviceInput?
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer! = {
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        return previewLayer
    }()

    
    
    func prepare(completionHandler: @escaping () -> Void) {
        
        DispatchQueue.global().async {
            do {
                try self.filterCameras()
                self.config(camera: self.rearCamera!)
                try self.configInputs()
                try self.configurePhotoOutput()
                self.captureSession.startRunning()
                self.startFollowingDeviceOrientation()
            } catch { }
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    
    
    private var devices: [AVCaptureDevice] {
        if #available(iOS 10.0, *) {
            let session = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                          mediaType: AVMediaTypeVideo,
                                                          position: .unspecified)
            
            guard let devices = session?.devices.flatMap({ $0 }), !devices.isEmpty else { return [] }
            return devices
        }
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice],
            !devices.isEmpty else { return [] }
        return devices
    }
    
    private func filterCameras() throws {
        for camera in devices {
            if camera.position == .front {
                frontCamera = camera
            } else if camera.position == .back {
                rearCamera = camera
            }
        }
    }
    
    private func config(camera: AVCaptureDevice) {
        guard let _ = try? camera.lockForConfiguration() else { return }
        camera.focusMode = .continuousAutoFocus
        camera.unlockForConfiguration()
    }
    
    private func addToSessionInput(for device: AVCaptureDevice) throws -> AVCaptureDeviceInput {
        let deviceInput = try AVCaptureDeviceInput(device: device)
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        return deviceInput
    }
    
    private func configInputs() throws {
        if let rearCamera = self.rearCamera {
            rearCameraInput = try addToSessionInput(for: rearCamera)
        }
        if let frontCamera = self.frontCamera {
            frontCameraInput = try addToSessionInput(for: frontCamera)
        }
    }
    
    func getData(handler: @escaping (Data?) -> Void) {
        guard let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) else { return }
        stillImageOutput.captureStillImageAsynchronously(from: videoConnection) { (imageDataSampleBuffer, error) -> Void in
            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            handler(data)
        }
    }
    
    func getImage(handler: @escaping (UIImage?) -> Void) {
        getData { data in
            guard let data = data else {
                return handler(nil)
            }
            handler(UIImage(data: data))
        }
    }
    
    
    private func configurePhotoOutput() throws {
        if #available(iOS 10.0, *) {
            let photoOutput = AVCapturePhotoOutput()
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
            photoOutput.setPreparedPhotoSettingsArray([settings], completionHandler: nil)
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
        } else {
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
        }
    }
    
    //---------
    
    func switchToFrontCamera() throws {
        guard let inputs = captureSession.inputs as? [AVCaptureInput],
            let rearCameraInput = self.rearCameraInput,
            inputs.contains(rearCameraInput),
            let frontCamera = self.frontCamera
            else { return }
        
        frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
        
        captureSession.removeInput(rearCameraInput)
        
        if captureSession.canAddInput(frontCameraInput!) {
            captureSession.addInput(frontCameraInput!)
            currentCameraPosition = .front
        }
    }
    
    
    //---------
    
    var shouldRespondToOrientationChanges = true
    var cameraIsObservingDeviceOrientation = false
    
    private func startFollowingDeviceOrientation() {
        if shouldRespondToOrientationChanges && !cameraIsObservingDeviceOrientation {
            NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            cameraIsObservingDeviceOrientation = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func orientationChanged() {
        previewLayer.connection.videoOrientation = UIDevice.current.videoOrientation
    }
}

extension UIDevice {
    var videoOrientation: AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
}
