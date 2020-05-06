//
//  TorchManager.swift
//  QRScanner
//
//  Created by Bondar Yaroslav on 26/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation
import AVFoundation

/// check for background
open class TorchManager {
    
    static let shared = TorchManager()
    
    private let device: AVCaptureDevice
    
    /// nil for simulator
    public init?() {
        #if targetEnvironment(simulator)
        print("- TorchManager: Torch is not available in simulator")
        return nil
        #else
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            assertionFailure("- TorchManager: Torch is not available. system error")
            return nil
        }
        self.device = device
        #endif
    }
    
    public func setupTorch(with handler: (_ device: AVCaptureDevice) throws -> Void) {
        do {
            try device.lockForConfiguration()
            try handler(device)
            device.unlockForConfiguration()
        } catch {
            print("- TorchManager: Torch could not be used:", error.localizedDescription)
        }
    }
    
    public func toggleTorch() {
        setupTorch { device in
            if device.torchMode == .on {
                device.torchMode = .off
            } else {
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }
            
            //device.torchMode = device.torchMode == .on ? .off : .on
        }
    }
    
    public func setTorchLevel(_ level: Float) {
        assert(level <= AVCaptureDevice.maxAvailableTorchLevel, "level: \(level) > max: \(AVCaptureDevice.maxAvailableTorchLevel)")
        setupTorch { try $0.setTorchModeOn(level: level) }
    }
}

