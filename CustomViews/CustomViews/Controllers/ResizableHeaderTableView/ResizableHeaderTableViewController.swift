//
//  ResizableHeaderTableViewController.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 29.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ResizableHeaderTableViewController: UITableViewController {
    
    let rowNumber = 30
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNumber
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Row " + String(indexPath.row + 1)
        return cell
    }
}
