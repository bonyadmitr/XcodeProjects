//
//  ViewController.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// localizedDescription: "The requested operation couldn’t be completed because the feature is not supported."
/// localized. example ru: "Операцию не удалось завершить, так как эта функция не поддерживается."
let unknownError = NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo: [:])

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = ClosureTapGesture { [unowned self] gesture in
            print("tap gesture", gesture.location(in: self.view))
        }
        view.addGestureRecognizer(tapGesture)
        
        
//        Result.success(())
//        let q = Result<Void>.failure(unknownError).error?.localizedDescription
//        print(q)
        
        
        print(Formatters.bytes(from: Device.totalDiskSpace))
        print(Formatters.bytes(from: Device.freeDiskSpace))
        print(Formatters.bytes(from: Device.usedDiskSpace))
        
        view.layer.cornerRadius = 40
    }
    
    @IBAction private func onCheckmarkAlertSheet(_ sender: UIButton) {
        showCheckmarkAlertSheet()
    }
    
    @IBAction private func onQLPreview(_ sender: UIButton) {
        let urls = [URL(string: "http://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf")!,
                    URL(string: "https://images.apple.com/environment/pdf/Apple_Environmental_Responsibility_Report_2017.pdf")!]
        let items = urls.map { RemotePreviewItem(url: $0) }
        
        let vc = PreviewController()
        vc.setup(withRemotes: items)
        present(vc, animated: true, completion: nil)
    }
}


// MARK: - showCheckmarkAlertSheet
extension ViewController {
    private func showCheckmarkAlertSheet() {
        let vc = UIAlertController(title: "title", message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "one ✔︎", style: .default, handler: nil)
        
        let action2 = UIAlertAction(title: "two", style: .default, handler: nil)
        action2.setValue(true, forKey: "checked")
        
        let action3 = UIAlertAction(title: "three", style: .default, handler: nil)
        if let image = textToImage("✔︎") {
            action3.setValue(image.withRenderingMode(.alwaysOriginal), forKey: "image")
        }
        
        vc.addAction(action1)
        vc.addAction(action2)
        vc.addAction(action3)
        
        present(vc, animated: true, completion: nil)
    }
    
    private func textToImage(_ text: String) -> UIImage? {
        
        //        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //        
        //        let img = renderer.image { ctx in
        //            // 2
        //            let paragraphStyle = NSMutableParagraphStyle()
        //            paragraphStyle.alignment = .center
        //            
        //            // 3
        //            let attrs = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSAttributedStringKey.paragraphStyle: paragraphStyle]
        //            
        //            // 4
        //            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
        //            string.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        //            
        //            // 5
        //            let mouse = UIImage(named: "mouse")
        //            mouse?.draw(at: CGPoint(x: 300, y: 150))
        //        }
        //        
        //        // 6
        //        imageView.image = img
        
        
        let imageSize = CGSize(width: 40, height: 40)
        let textColor = UIColor.defaultBlue
        let textFont = UIFont(name: "Helvetica Bold", size: 20)!
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        
        //        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.alignment = .left
        //        .paragraphStyle: paragraphStyle
        
        let textAttributes: [NSAttributedStringKey: Any] = [.font: textFont,
                                                            .foregroundColor: textColor]
        
        let textSize = (text as NSString).size(withAttributes: textAttributes)
        
        let startPoint = CGPoint(x: textSize.width / 2, y: textSize.height / 2)
        
        let rect = CGRect(origin: startPoint, size: imageSize)
        text.draw(in: rect, withAttributes: textAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


func roundAppCorners() {
    /// CHECK with animations
    /// but need it?
    /// https://www.google.by/search?newwindow=1&ei=o_SJWqLAKcrQwQKPlLC4Bg&q=swift+cornerRadius+for+window&oq=swift+cornerRadius+for+window&gs_l=psy-ab.3..33i21k1j33i160k1l2.7864.8591.0.8831.6.6.0.0.0.0.156.641.0j5.5.0....0...1c.1.64.psy-ab..1.5.639...0i22i30k1j0i22i10i30k1.0.8qssvCSHN-Y
    let window = UIApplication.shared.windows.last
    window?.clipsToBounds = true
    window?.layer.cornerRadius = 5
    window?.backgroundColor = UIColor.black
}
