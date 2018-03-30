//
//  Images.swift
//  Customization
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum Images {
    private static let backgroundImageKey = "backgroundImage"
    static var background: UIImage? {
        get { return UserDefaults.standard.image(forKey: backgroundImageKey) ?? #imageLiteral(resourceName: "im_cloud") }
        set { UserDefaults.standard.set(newValue, forKey: backgroundImageKey) }
    }
}
