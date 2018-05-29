//
//  TableViewController.swift
//  TableViewTransparentEdges
//
//  Created by zdaecqze zdaecq on 14.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "Index \(indexPath.row)"
        return cell
    }

}
