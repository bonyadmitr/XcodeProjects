//
//  UserDefaults+UIImage.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 21/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UserDefaults {
    @nonobjc
    func set(_ image: UIImage?, forKey key: String) {
        guard let image = image, let data = UIImageJPEGRepresentation(image, 1) else { return }
        set(data, forKey: key)
    }
    func image(forKey key: String) -> UIImage? {
        guard let data = object(forKey: key) as? Data, let image = UIImage(data: data) else { return nil }
        return image
    }
}
