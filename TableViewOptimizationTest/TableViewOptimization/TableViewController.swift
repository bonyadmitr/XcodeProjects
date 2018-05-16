//
//  TableViewController.swift
//  TableViewOptimization
//
//  Created by Bondar Yaroslav on 29.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10000
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
//        if indexPath.row % 2 == 0 {
//        cell.someImage.image = #imageLiteral(resourceName: "Ferrari")
//        } else {
//            cell.someImage.image = #imageLiteral(resourceName: "iTunesArtwork")
//        }
        
        // image
        
        cell.someImage.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.someImage.layer.shadowOpacity = 0.8
        cell.someImage.layer.shadowPath = UIBezierPath(rect: cell.someImage.bounds).cgPath
        
//        cell.someImage.layer.shouldRasterize = true
//        cell.someImage.layer.rasterizationScale = UIScreen.main.scale
        
        cell.label.text = "Row \(indexPath.row + 1)"
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = cell as! TableViewCell
//        
//
//        
//    }
}
