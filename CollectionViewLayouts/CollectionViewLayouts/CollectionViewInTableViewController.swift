//
//  CollectionViewInTableViewController.swift
//  Calendar2
//
//  Created by zdaecqze zdaecq on 29.08.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class CollectionViewInTableViewController: UIViewController {
    @IBOutlet weak var tableView: CollectionTableView!
    var calender = [1,2,3,4,5,6,7,8,9,10]
}

extension CollectionViewInTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calender.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
//        self.tableView.currentRow = indexPath.row
        cell.tableView = self.tableView
        cell.indexPath = indexPath
        
        let number = calender[indexPath.row]
        cell.config(with: number)
        
        return cell
    }
}
