//
//  ViewController.swift
//  QRScanner
//
//  Created by Bondar Yaroslav on 11/24/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import AVFoundation

/// https://github.com/appcoda/QRCodeReader/blob/master/QRCodeReader/QRScannerController.swift
/// https://www.appcoda.com/barcode-reader-swift/
class ViewController: UIViewController {

    let scanner = QRScanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner.setup()
        view.layer.addSublayer(scanner.videoPreviewLayer)
        //scanner.videoPreviewLayer.frame = view.bounds
        
        view.addSubview(scanner.qrCodeFrameView)
        view.bringSubview(toFront: scanner.qrCodeFrameView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scanner.videoPreviewLayer.frame = view.bounds
    }
}

final class ViewController2: UIViewController {
    
    private let scanner = CodeCameraScanner()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layer = scanner.prepareVideoPreviewLayer() {
            //layer.frame = view.bounds
            view.layer.addSublayer(layer)
            videoPreviewLayer = layer
            scanner.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scanner.start()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = view.bounds
        videoPreviewLayer?.connection?.videoOrientation = UIDevice.current.videoOrientation
    }
}

extension ViewController2: CodeCameraScannerDelegate {
    func codeCameraScanner(_ scanner: CodeCameraScanner, didDetect text: String) {
        scanner.stop()
        UIAlertView(title: text, message: nil, delegate: nil, cancelButtonTitle: "OK").show()
    }
}
