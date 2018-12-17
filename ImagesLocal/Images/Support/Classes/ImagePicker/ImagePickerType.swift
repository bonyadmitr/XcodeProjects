//
//  ImagePickerType.swift
//  Images
//
//  Created by Bondar Yaroslav on 30/01/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum ImagePickerType {
    case photoLibrary
    case camera
}
extension ImagePickerType {
    var imagePickerType: UIImagePickerControllerSourceType? {
        switch self {
        case .photoLibrary:
            return .photoLibrary
        case .camera:
            return .camera
        }
    }
}
