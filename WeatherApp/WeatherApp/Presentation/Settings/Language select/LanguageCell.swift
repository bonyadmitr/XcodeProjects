//
//  LanguageCell.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 21/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class LanguageCell: UITableViewCell {
    func fill(with object: String) {
        textLabel?.text = object
    }
}
