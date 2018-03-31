//
//  DetailViewController.swift
//  GenericTableViewController
//
//  Created by zdaecqze zdaecq on 03.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel? {
        didSet {
            label?.text = episode?.title
        }
    }
    
    var episode: Episode?
}
