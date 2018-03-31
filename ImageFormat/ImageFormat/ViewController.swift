//
//  ViewController.swift
//  ImageFormat
//
//  Created by Bondar Yaroslav on 2/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for file in ["1.jpg", "2.png", "3.gif", "4.svg", "5.TIF", "6.webp", "7.HEIC"] {
            if let data = Data(bundleFileName: file) {
                print(file, ImageFormat.get(from: data))
            }
        }
        
        
        if #available(iOS 11.0, *) {
            /// not working in simulator
            guard let bundlePath = Bundle.main.path(forResource: "7.HEIC", ofType: ""),
                let url = URL(string: bundlePath),
                let ciImage = CIImage(contentsOf: url)
                else { return }
            
            let image = UIImage(ciImage: ciImage)
            let data = image.heicRepresentation(quality: 1)!
            print("heicRepresentation", ImageFormat.get(from: data))
            
            if let image = UIImage(named: "7.HEIC"),
                let data = image.heicRepresentation(quality: 1) {
                print("heicRepresentation", ImageFormat.get(from: data))
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

//Data+Init
extension Data {
    /// Example
    /**
     if let data = Data(bundleFileName: "1.jpg") { }
     */
    init?(bundleFileName: String) {
        guard let bundlePath = Bundle.main.path(forResource: bundleFileName, ofType: "") else {
            return nil
        }
        try? self.init(contentsOf: URL(fileURLWithPath: bundlePath), options: .mappedIfSafe)
    }
}
