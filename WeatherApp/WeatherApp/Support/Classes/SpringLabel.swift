//
//  SpringLabel.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 04/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

// superfluous_disable_command vertical_parameter_alignment_on_call
open class SpringLabel: UILabel {
    
    open lazy var duration = 0.1
    
    open override var text: String? {
        didSet {
            if text == oldValue {
                return
            }
            UIView.animate(withDuration: duration) {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            UIView.animate(withDuration: duration, delay: duration, options: [], animations: {
                self.transform = .identity
            }, completion: nil)
        }
    }
}
// swiftlint:enable vertical_parameter_alignment_on_call
