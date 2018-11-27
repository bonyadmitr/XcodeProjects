//
//  UITableViewCell+Color.swift
//  Settings
//
//  Created by Yaroslav Bondar on 27/11/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func setSelectionColor(_ color: UIColor) {
        let selectedView = UIView()
        selectedView.backgroundColor = color
        selectedBackgroundView = selectedView
    }
}
