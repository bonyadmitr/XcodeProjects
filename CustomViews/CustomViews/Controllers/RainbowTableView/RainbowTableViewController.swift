//
//  RainbowTableViewController.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 29.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class RainbowTableViewController: UITableViewController {
    
    let rowNumber = 100
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNumber
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Row " + String(indexPath.row + 1)
        
        // color for rainbow
        let hue = CGFloat(indexPath.row)/CGFloat(rowNumber)
        cell.backgroundColor = UIColor(hue: hue, saturation: 0.7, brightness: 0.8, alpha: 1.0)
        
        return cell
    }
}
