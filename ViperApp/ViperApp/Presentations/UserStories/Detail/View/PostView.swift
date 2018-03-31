//
//  PostView.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 30/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class PostView: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var userIdLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    
    func fill(with post: Post) {
        titleLabel.text = post.title
        idLabel.text = "ID: \(post.id)"
        userIdLabel.text = "UserID: \(post.userId)"
        bodyLabel.text = post.body
    }
}
