//
//  SettingsRouter.swift
//  Images
//
//  Created by Bondar Yaroslav on 30/01/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class SettingsRouter {
    
    func openSettings() {
        guard
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString),
            UIApplication.shared.canOpenURL(settingsUrl)
            else {
                return
        }
        UIApplication.shared.openURL(settingsUrl)
    }
    
    func presentSettingsAlert(in controller: UIViewController, title: String?, message: String?) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            self.openSettings()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        alertVC.addAction(settingsAction)
        
        DispatchQueue.main.async {
            controller.present(alertVC, animated: true, completion: nil)
        }
    }
}

extension SettingsRouter {
    func presentSettingsAlertForPhotoAccess(in controller: UIViewController) {
        presentSettingsAlert(in: controller,
                             title: "Photos access disabled",
                             message: "You can enable access to photos in Settings")
    }
    
    func presentSettingsAlertForCameraAccess(in controller: UIViewController) {
        presentSettingsAlert(in: controller,
                             title: "Camera access disabled",
                             message: "You can enable access to camera in Settings")
    }
    
    func presentSettingsAlertForLocationAccess(in controller: UIViewController) {
        presentSettingsAlert(in: controller,
                             title: "Location access disabled",
                             message: "You can enable access to location in Settings")
    }
}
