//
//  ViewController.swift
//  DynamicCell
//
//  Created by Bondar Yaroslav on 17/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataSource = TableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        dataSource.tableView = tableView
        
        /// uncomment this string and remove heightForRowAt method to simplify
        /// but I don't recommend. read in heightForRowAt method
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    /// reusable for UITableViewAutomaticDimension
    var heightsCache: [IndexPath: CGFloat] = [:]
}

extension ViewController: UITableViewDelegate {
    
    /// And if the tableview has a lot of rows, you should return an approximate value for height in estimatedHeightForRowAtIndexPath to speed up the loading process of the view controller
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /// was 10 calculations without cache
        /// with it only 5 times (dataSource.someArray.count)
        /// and will caculate for every new display cell
        if let height = heightsCache[indexPath] {
            return height
        }
        
        let height = UITableViewAutomaticDimension
        heightsCache[indexPath] = height
        print(indexPath)
        return height
    }
}
