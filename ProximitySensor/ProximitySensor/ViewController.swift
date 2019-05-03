import UIKit
import AVFoundation

final class ViewController: UIViewController {

    @IBOutlet private weak var someLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateProximitySensor()
    }
    
    /// https://developer.apple.com/documentation/uikit/uidevice/1620017-isproximitymonitoringenabled
    func isProximityMonitoringAvailable() -> Bool {
        UIDevice.current.isProximityMonitoringEnabled = true
        let isAvailable = UIDevice.current.isProximityMonitoringEnabled
        UIDevice.current.isProximityMonitoringEnabled = false
        return isAvailable
    }

    /// not working in lanscape
    /// https://stackoverflow.com/a/8677732/5893286
    ///
    private func activateProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: UIDevice.proximityStateDidChangeNotification, object: nil)
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
            
            /// real toggle
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

