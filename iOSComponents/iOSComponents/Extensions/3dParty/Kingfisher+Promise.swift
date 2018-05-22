//
//  Kingfisher+Promise.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 04/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import PromiseKit
import Kingfisher

extension ImageDownloader {
    func downloadImage(with url: URL) -> Promise<UIImage> {
        return Promise(resolvers: { (fulfill, reject) in
            downloadImage(with: url) { (image, error, _, _) in
                if let err = error {
                    reject(err)
                } else if let im = image {
                    fulfill(im)
                }
            }
        })
    }
}
