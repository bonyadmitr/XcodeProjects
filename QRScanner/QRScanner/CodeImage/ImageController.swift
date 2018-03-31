//
//  ImageController.swift
//  QRScanner
//
//  Created by Bondar Yaroslav on 26/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ImageController: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    @IBAction func actionPickButton(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        qrImageView.image = CodeGenerator.shared.generateBarcode(from: "hello")
        //qrImageView.image = CodeGenerator.shared.convertTextToQRCode(text: "hello", size: qrImageView.bounds.size)
    }
    
    @IBAction func actionTorchBarButton(_ sender: UIBarButtonItem) {
        TorchManager.shared?.toggleTorch()
    }
}

extension ImageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let inputImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        print("native", CodeDetector.shared.readQR(from: inputImage) ?? "nil")
        print("ZXingObjC", CodeDetector.shared.readAnyCode(from: inputImage) ?? "nil")
        
        dismiss(animated: true, completion: nil)
        
    }
}
