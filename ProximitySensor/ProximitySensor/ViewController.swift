import UIKit
import AVFoundation

final class ViewController: UIViewController {

    @IBOutlet private weak var someLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateProximitySensor()
    }

     private func activateProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: UIDevice.proximityStateDidChangeNotification, object: nil)
//        let device = UIDevice.currentDevice()
//        device.proximityMonitoringEnabled = true
//        if device.proximityMonitoringEnabled {
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: "proximityChanged:", name: "UIDeviceProximityStateDidChangeNotification", object: device)
//
//        }
    }

    @objc private func proximityChanged() {
        let proximityState = UIDevice.current.proximityState
        someLabel.text = String(proximityState)
        print("proximityState:", proximityState)
        toggleFlash(turnOn: proximityState)
    }
    
    func toggleFlash(turnOn: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if turnOn {
                try device.setTorchModeOn(level: 1.0)
            } else {
                device.torchMode = .off
            }
            
//            if device.torchMode == .on {
//                device.torchMode = .off
//            } else {
//                try device.setTorchModeOn(level: 1.0)
//            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }

}

