//
//  QBImagePickerController+NavVC.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 09.08.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import QBImagePickerController

extension QBImagePickerController {
    var navVC : UINavigationController {
        return valueForKey("albumsNavigationController") as! UINavigationController
    }
}