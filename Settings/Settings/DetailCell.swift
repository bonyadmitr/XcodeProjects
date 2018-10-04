//
//  DetailCell.swift
//  Settings
//
//  Created by Bondar Yaroslav on 30/09/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class DetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let textLabel = textLabel, let detailTextLabel = detailTextLabel else {
            assertionFailure()
            return
        }
        
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        detailTextLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        isAccessibilityElement = true
        if #available(iOS 10.0, *) {
//            textLabel.adjustsFontForContentSizeCategory = true
//            detailTextLabel.adjustsFontForContentSizeCategory = true
        }
        if #available(iOS 11.0, *) {
            //accessibilityIgnoresInvertColors = true
            //imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
            
            //let q = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
            
            textLabel
                .firstBaselineAnchor
                .constraintEqualToSystemSpacingBelow(detailTextLabel.lastBaselineAnchor, multiplier: 1.0)
            
            
        }
    }
    
    /// call before setup method for correct accessibilityLabel
    var isChecked = false {
        didSet {
            accessoryType = isChecked ? .checkmark : .none
        }
    }
    
    func setup(title: String, subtitle: String?) {
        textLabel?.text = title
        detailTextLabel?.text = subtitle
        
        // MARK: setup accessibilityLabel
        
        var accessLabel = title
        if let subtitle = subtitle {
            accessLabel += ", \(subtitle)"
        }
        
        // TODO: maybe this don't need. need to check
        if isChecked {
            accessLabel += ". checked"
        }
        
        accessibilityLabel = accessLabel
    }
    
//    override func accessibilityActivate() -> Bool {
//        let text = "Language selected"
//        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
//        return true
//    }
}
