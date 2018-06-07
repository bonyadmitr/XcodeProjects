//
//  UIImageView+Scale.swift
//  LifeboxShared
//
//  Created by Bondar Yaroslav on 3/6/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import UIKit

extension UIImageView {
    func setScreenScaledImage(_ newImage: UIImage?) {
        guard let newImage = newImage else {
            return
        }
        DispatchQueue.global().async {
            let resizedImage = newImage.resizedImage(to: self.bounds.size.screenScaled)
            DispatchQueue.main.async {
                self.image = resizedImage
            }
        }
    }
}
