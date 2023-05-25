//
//  ViewController2.swift
//  TextInputBar
//
//  Created by Yaroslav Bondar on 12.04.2023.
//

import UIKit

class ViewController2: UIViewController {
    
    private let textInputBar = TextInputBar.initFromNib()
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var bottomTextInputBarConstraint = textInputBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    
    
}
