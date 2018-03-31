//
//  ViewController.swift
//  Images
//
//  Created by Bondar Yaroslav on 28/01/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var mainColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    
    private lazy var imagePicker = ImagePicker().setup { /// optional customization
        $0.settings = ImagePickerSettings(barTintColor: self.mainColor, tintColor: .white, barStyle: .black)
    }
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var pickPhotoButton: UIButton! {
        didSet {
            ///IB buttonType = .custom
            pickPhotoButton.setTitle("Pick photo", for: .normal)
            pickPhotoButton.setTitleColor(UIColor.white, for: .normal)
            pickPhotoButton.setTitleColor(UIColor.white.darker(), for: .highlighted)
            pickPhotoButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            pickPhotoButton.setBackgroundColor(mainColor, for: .normal)
            pickPhotoButton.setBackgroundColor(mainColor.darker(), for: .highlighted)
        }
    }
    
    @IBAction private func actionPickPhotoButton(_ sender: UIButton) {
        
        /// sample 1
        imagePicker.openPicker(in: self) { [weak self] image in
            self?.photoImageView.image = image
        }
        
        /// sample 2
//        imagePicker.requestCameraAccess { [weak self] result in
//            guard let `self` = self else { return}
//
//            switch result {
//            case .authorized:
//                self.imagePicker.openPicker(in: self, for: .camera) { [weak self] image in
//                    guard let `self` = self else { return}
//                    self.photoImageView.image = image
//                }
//            case .denied:
//                print("denied")
//                break
//            }
//        }
        
        /// sample 3
//        imagePicker.requestPhotoAccess { [weak self] result in
//            guard let `self` = self else { return}
//
//            switch result {
//            case .authorized:
//                self.imagePicker.openPicker(in: self, for: .photoLibrary) { [weak self] image in
//                    guard let `self` = self else { return}
//                    self.photoImageView.image = image
//                }
//            case .denied:
//                print("denied")
//                break
//            }
//        }
    }
}
