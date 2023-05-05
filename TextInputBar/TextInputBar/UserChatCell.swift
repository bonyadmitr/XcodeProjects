//
//  UserChatCell.swift
//  TextInputBar
//
//  Created by Yaroslav Bondar on 14.04.2023.
//

import UIKit

final class UserChatCell: UITableViewCell {

    @IBOutlet weak var textBackgroundView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textBackgroundView.layer.cornerRadius = 16
        textBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func setup(with text: String) {
        messageLabel.text = text
    }
    
    
    
}
