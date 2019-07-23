//
//  ViewController.swift
//  QRScreenScanner
//
//  Created by Bondar Yaroslav on 7/23/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var screenImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction private  func captureScreen(_ sender: NSButton) {
        let window = view.window!
        
        window.orderOut(self)
        //window.close()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            guard let img = CGDisplayCreateImage(CGMainDisplayID()) else {
                assertionFailure()
                return
            }
            
            
            self.screenImageView.image = NSImage(cgImage: img, size: .init(width: img.width, height: img.height))
            
            window.makeKeyAndOrderFront(nil)
            /// addition if need
            //NSApp.activate(ignoringOtherApps: true)
            /// not work
            //window.orderBack(self)
            
            print(
                CodeDetector.shared.readQR(from: img)
            )
        }
        

        
    }
    
}

final class CodeDetector {
    
    static let shared = CodeDetector()
    
    /// native
    func readQR(from image: NSImage) -> [String] {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            assertionFailure("cgImage convert problem")
            return []
        }
        return readQR(from: cgImage)
    }
    
    func readQR(from image: CGImage) -> [String] {
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                     context: nil,
                                     options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        else {
            assertionFailure("nil in simulator, A7 core +")
            return []
        }
        
        let ciImage = CIImage(cgImage: image)
        
        guard let features = detector.features(in: ciImage) as? [CIQRCodeFeature] else {
            assertionFailure("CIDetector(ofType is different")
            return []
        }
        
        return features.compactMap({$0.messageString})
    }
}
