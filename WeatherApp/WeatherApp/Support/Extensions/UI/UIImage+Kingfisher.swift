//
//  UIImage+Kingfisher.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImage {
    func image(for size: CGSize, mode: ContentMode = .none) -> UIImage? {
        let resizer = ResizingImageProcessor(referenceSize: size, mode: .aspectFill)
        let img = resizer.process(item: .image(self), options: [])
        return img
    }
}
