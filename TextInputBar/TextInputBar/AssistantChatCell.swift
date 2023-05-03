//
//  AssistantChatCell.swift
//  TextInputBar
//
//  Created by Yaroslav Bondar on 14.04.2023.
//

import UIKit

class AssistantChatCell: UITableViewCell {

    @IBOutlet weak var textBackgroundView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textBackgroundView.layer.cornerRadius = 16
        textBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setup(with text: String) {
        messageLabel.text = text
    }
    
}
