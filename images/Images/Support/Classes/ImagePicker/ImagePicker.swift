//
//  ImagePicker.swift
//  Images
//
//  Created by Bondar Yaroslav on 29/01/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Photos

typealias ResponseImage = (_ image: UIImage) -> Void

/**
add to Info.plist

 1) Camera:
NSCameraUsageDescription

 2) Photo Library:
NSPhotoLibraryUsageDescription
 */

final class ImagePicker: NSObject {
    
    /// better to use UINavigationBar.appearance() for gloabl customization
    /// use "settings" if need set colors over UINavigationBar.appearance()
    var settings: ImagePickerSettings?
    
    private lazy var settingsRouter = SettingsRouter()
    private lazy var permissionsManager = PermissionsManager()
    
    private var handler: ResponseImage?
    
    func openPicker(in vc: UIViewController, for type: ImagePickerType, handler: @escaping ResponseImage) {
        self.handler = handler
        
        guard let imagePickerType = type.imagePickerType else {
            /// open another picker
            return
        }
        
        /// only .camera is not available in simulator
        guard UIImagePickerController.isSourceTypeAvailable(imagePickerType) else {
            return print("- not Available \(imagePickerType)")
        }
        
        let picker = imagePicker(for: imagePickerType)
        
        DispatchQueue.main.async {
            vc.present(picker, animated: true, completion: nil)
        }
    }
    
    private func imagePicker(for type: UIImagePickerControllerSourceType) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.modalPresentationStyle = .overCurrentContext /// to turn on landscape mode
        picker.modalPresentationCapturesStatusBarAppearance = true
//        picker.allowsEditing = true
        setupPickerBySettings(picker)
        return picker
    }
    
    private func setupPickerBySettings(_ picker: UIImagePickerController) {
        if let settings = settings {
            let navBar = picker.navigationBar
            
            if let barTintColor = settings.barTintColor {
                navBar.barTintColor = barTintColor
            }
            if let barStyle = settings.barStyle {
                navBar.barStyle = barStyle
            }
            if let tintColor = settings.tintColor {
                navBar.tintColor = tintColor
                navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: tintColor]
            }
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            handler?(image)
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            handler?(image)
        } else {
            print("- ImagePicker ERROR: Something went wrong with UIImagePickerController")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImagePicker {
    func openPicker(in vc: UIViewController, handler: @escaping ResponseImage) {
        
        let alertVC = UIAlertController(title: "Choose source", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.permissionsManager.requestCameraAccess { [weak self] result in
                guard let `self` = self else { return }
                
                switch result {
                case .success:
                    self.openPicker(in: vc, for: .camera) { image in
                        handler(image)
                    }
                case .denied:
                    self.settingsRouter.presentSettingsAlertForCameraAccess(in: vc)
                }
            }
        }
        
        let libraryAction = UIAlertAction(title: "Photo library", style: .default) { _ in
            self.permissionsManager.requestPhotoAccess { [weak self] result in
                guard let `self` = self else { return}
                
                switch result {
                case .success:
                    self.openPicker(in: vc, for: .photoLibrary) { image in
                        handler(image)
                    }
                case .denied:
                    self.settingsRouter.presentSettingsAlertForPhotoAccess(in: vc)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        
        DispatchQueue.main.async {
            vc.present(alertVC, animated: true, completion: nil)
        }
    }
}
