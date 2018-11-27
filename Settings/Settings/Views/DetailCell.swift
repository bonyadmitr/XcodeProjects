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

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    private let spaceBetweenLabels: CGFloat = 8
    
    /// call before setup method for correct accessibilityLabel
    var isChecked = false {
        didSet {
            accessoryType = isChecked ? .checkmark : .none
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //guard let textLabel = textLabel, let detailTextLabel = detailTextLabel else {
        guard let textLabel = titleLabel, let detailTextLabel = subtitleLabel else {
            assertionFailure()
            return
        }
        
        detailTextLabel.text = " "
        
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
    
    func setup(title: String, subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        // MARK: setup accessibilityLabel
        
        var newAccessibilityLabel = title
        if let subtitle = subtitle {
            newAccessibilityLabel += ", \(subtitle)"
        }
        
        // TODO: maybe this don't need. need to check
        // TODO: improve for rtl
        if isChecked {
            newAccessibilityLabel += ". " + L10n.checked
        }
        
        accessibilityLabel = newAccessibilityLabel
    }
    
    func height() -> CGFloat {
        var minHeight: CGFloat = 0
        
        if let title = titleLabel.text {
            let titleHeight = title.height(for: contentView.bounds.width, font: titleLabel.font)
            minHeight += titleHeight
        }
        
        if let subtitle = subtitleLabel.text {
            let subtitleHeight = subtitle.height(for: contentView.bounds.width, font: subtitleLabel.font)
            minHeight += subtitleHeight
            minHeight += spaceBetweenLabels
        }
        
        return minHeight < Constants.minCellHeight ? Constants.minCellHeight : minHeight
    }
    
//    override func accessibilityActivate() -> Bool {
//        let text = "Language selected"
//        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
//        return true
//    }
}
