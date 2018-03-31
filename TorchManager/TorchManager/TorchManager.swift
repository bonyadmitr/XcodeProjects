//
//  TorchManager.swift
//  TorchManager
//
//  Created by Bondar Yaroslav on 26/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation
import AVFoundation

/// check for background
open class TorchManager {
    
    //static let shared = TorchManager()
    
    private let device: AVCaptureDevice
    
    /// nil for simulator
    public init?() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            print("- TorchManager: Torch is not available")
            return nil
        }
        self.device = device
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
    
    open func toggleTorch() {
        setupTorch { device in
            device.torchMode = device.torchMode == .on ? .off : .on
        }
    }
}

final class StorageTorchManager: TorchManager {
    
    static let shared = StorageTorchManager()
    
    var saveLevelForToggle = true
    private var torchLevel: Float = 0
    
    func setTorch(level: Float) {
        setupTorch { device in
            if level == 0 {
                device.torchMode = .off
            } else {
                if saveLevelForToggle {
                    torchLevel = level
                }
                try device.setTorchModeOn(level: level)
            }
        }
    }
    
    override func toggleTorch() {
        setupTorch { device in
            if device.torchMode == .on {
                device.torchMode = .off
            } else {
                if saveLevelForToggle {
                    setTorch(level: torchLevel)
                } else {
                    try device.setTorchModeOn(level: 1)
                }
            }
        }
    }
}
