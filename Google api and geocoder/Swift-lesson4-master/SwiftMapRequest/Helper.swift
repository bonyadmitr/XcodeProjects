//
//  Helper.swift
//  SwiftMapRequest
//
//  Created by Rustam N on 09.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import MapKit


func GetAnnotation(data: AnnotationDataStruct)->  MKPointAnnotation {
    let annotation = MKPointAnnotation()
    annotation.title = data.placeName
    annotation.subtitle = data.address
    annotation.coordinate = data.coordinate
    return annotation
    
}


func ErrorAllert(alertTitle: String, message: String, actionTitle: String, controller: UIViewController) {
    let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.cancel, handler: nil))
    controller.present(alert, animated: true, completion: nil)
}



extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
