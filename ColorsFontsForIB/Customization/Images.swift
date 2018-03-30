//
//  Images.swift
//  Customization
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

struct Images {
    private init() {}
    
    private static let backgroundImageKey = "backgroundImage"
    static var background: UIImage? {
        get {
            guard let data = UserDefaults.standard.object(forKey: backgroundImageKey) as? Data,
                let image = UIImage(data: data)
                else { return #imageLiteral(resourceName: "Ferrari") }
            return image
        }
        set {
            guard let image = newValue else {
                UserDefaults.standard.set(nil, forKey: backgroundImageKey)
                return
            }
            let imageData = UIImageJPEGRepresentation(image, 1)
            UserDefaults.standard.set(imageData, forKey: backgroundImageKey)
        }
    }
}
