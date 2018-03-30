//
//  FontCell.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 16/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class FontCell: UITableViewCell {
    func fill(with fontName: String) {
        let font = UIFont(name: fontName, size: 17)
        textLabel?.text = fontName
        textLabel?.font = font
    }
}
