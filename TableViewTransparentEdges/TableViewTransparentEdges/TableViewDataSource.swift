//
//  TableViewDataSource.swift
//  TableViewTransparentEdges
//
//  Created by zdaecqze zdaecq on 14.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject {
    var array = [String]()
}

extension TableViewDataSource: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = array[indexPath.row]
        return cell
    }
    
}