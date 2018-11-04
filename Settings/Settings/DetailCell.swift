//
//  DetailCell.swift
//  Settings
//
//  Created by Bondar Yaroslav on 30/09/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// fixed appearance in LanguageSelectController by new DetailCell nib
/// don't use standart labels (textLabel), setting textColor is not working in subclass
final class DetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //guard let textLabel = textLabel, let detailTextLabel = detailTextLabel else {
        guard let textLabel = titleLabel, let detailTextLabel = subtitleLabel else {
            assertionFailure()
            return
        }
        
        detailTextLabel.text = ""
        
        /// need for iOS 10, don't need for iOS 11
        textLabel.numberOfLines = 0
        detailTextLabel.numberOfLines = 0
        
//        textLabel.minimumScaleFactor = 0.5
//        textLabel.adjustsFontSizeToFitWidth = true
        
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        detailTextLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        isAccessibilityElement = true
        
        if #available(iOS 10.0, *) {
            /// don't need to be set manualy
            textLabel.adjustsFontForContentSizeCategory = true
            detailTextLabel.adjustsFontForContentSizeCategory = true
        }
        if #available(iOS 11.0, *) {
            /// for custom font:
            //titleLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
            //titleLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFont)
            
            //accessibilityIgnoresInvertColors = true
            //imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
            
            //let q = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
            
//            textLabel
//                .firstBaselineAnchor
//                .constraintEqualToSystemSpacingBelow(detailTextLabel.lastBaselineAnchor, multiplier: 1.0)
        }
    }
    
    /// call before setup method for correct accessibilityLabel
    var isChecked = false {
        didSet {
            accessoryType = isChecked ? .checkmark : .none
        }
    }
    
    func setup(title: String, subtitle: String? = nil) {
        titleLabel?.text = title
        subtitleLabel?.text = subtitle
        
        // MARK: setup accessibilityLabel
        
        var newAccessibilityLabel = title
        if let subtitle = subtitle {
            newAccessibilityLabel += ", \(subtitle)"
        }
        
        // TODO: maybe this don't need. need to check
        if isChecked {
            newAccessibilityLabel += ". checked"
        }
        
        accessibilityLabel = newAccessibilityLabel
    }
    
//    override func accessibilityActivate() -> Bool {
//        let text = "Language selected"
//        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
//        return true
//    }
}
