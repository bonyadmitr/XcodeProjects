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
        
        isAccessibilityElement = true  
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
    
    override func accessibilityActivate() -> Bool {
        let text = "Language selected"
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
        return true
    }
}
