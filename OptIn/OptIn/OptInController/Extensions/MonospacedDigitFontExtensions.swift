//
//  MonospacedDigitFont.swift
//  Timer
//
//  Created by Bondar Yaroslav on 14/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UILabel {
    func setMonospacedDigitFont() {
        font = font.monospacedDigitFont
    }
}

/// https://stackoverflow.com/a/30981587
extension UIFont {
    var monospacedDigitFont: UIFont {
        let oldFontDescriptor = fontDescriptor
        let newFontDescriptor = oldFontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
}

private extension UIFontDescriptor {
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [
            [UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
             UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]
        ]
        let fontDescriptorAttributes = [UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings]
        return addingAttributes(fontDescriptorAttributes)
    }
}
