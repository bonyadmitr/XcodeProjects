//
//  ViewController.swift
//  TableViewTransparentEdges
//
//  Created by zdaecqze zdaecq on 14.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: DPTransparentEdgesTableView!
    var dataSource = TableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.gradientLengthFactor = 0.2
        tableView.topMaskDisabled = true
        tableView.dataSource = dataSource
        dataSource.array = ["a", "fdfgdfg", "123"]
    }

}

