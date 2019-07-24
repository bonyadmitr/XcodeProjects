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
    
    /// required NSTableView cell-based content mode in IB
    @IBOutlet private var historyArrayController: NSArrayController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[arrayController addObserver:self forKeyPath:@"selectionIndexes" options:0 context:&kvoContext];
        
        /// NSDictionary
        let s1: [String: Any] = ["date": 111, "value": "qqweqwe"]
        let s2: [String: Any] = ["date": 222, "value": "573457yufguy"]
        
        
        historyArrayController.addObserver(self, forKeyPath: #keyPath(NSArrayController.selectionIndexes), options: [], context: nil)
        historyArrayController.content = [s1, s2]
    }
    
    deinit {
        historyArrayController.removeObserver(self, forKeyPath: #keyPath(NSArrayController.selectionIndexes))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath {
        case #keyPath(NSArrayController.selectionIndexes):
            updateUIWithSelection()
            
        default:
            assertionFailure()
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateUIWithSelection() {
        guard let selectedObjects = historyArrayController.selectedObjects as? [[String: Any]] else {
            assertionFailure()
            return
        }
        print(selectedObjects)
    }

//    override var representedObject: Any? {
//        didSet {
//        // Update the view, if already loaded.
//        }
//    }

//    @IBAction private  func captureScreen(_ sender: NSButton) {
//        let window = view.window!
//
//        window.orderOut(self)
//        //window.close()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//
//            guard let img = CGDisplayCreateImage(CGMainDisplayID()) else {
//                assertionFailure()
//                return
//            }
//
//
//            self.screenImageView.image = NSImage(cgImage: img, size: .init(width: img.width, height: img.height))
//
//            window.makeKeyAndOrderFront(nil)
//            /// addition if need
//            //NSApp.activate(ignoringOtherApps: true)
//            /// not work
//            //window.orderBack(self)
//
//            print(
//                CodeDetector.shared.readQR(from: img)
//            )
//        }
//
//
//
//    }
    
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
