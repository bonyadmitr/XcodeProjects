//
//  UIView+Fonts.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 15/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIView {
    func updateAllLabeles(with fontName: String) {
        subviews
            .execute { $0.updateAllLabeles(with: fontName) }
            .flatMap { $0 as? UILabel }
            .forEach { $0.font = UIFont(name: fontName, size: $0.font.pointSize) }
    }
}
