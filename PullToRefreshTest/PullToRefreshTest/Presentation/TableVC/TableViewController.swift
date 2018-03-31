//
//  TableViewController.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 15/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let dataSource = TableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.tableView = tableView
        
        /// set in IB or in refreshControl of UITableViewController
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
         /// need to comment to remove lag with fast inset for ios 9
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        /// need for iOS 10 to make it under tableView
        refreshControl?.layer.zPosition = -1
        
        /// to remove freeze for iOS 9
//        tableView.contentOffset = CGPoint(x: 0, y: -1)
        
        
//        tableView.addRefreshControl(title: "Pull to refresh", color: .blue) { refreshControl in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                print("refreshData")
//                self.dataSource.someArray = self.dataSource.someArray.reversed()
//                refreshControl.endRefreshing()
//            }
//        }
    }
    
    func refreshData(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: globalPullToRefreshDelay) {
            print("refreshData")
            self.dataSource.someArray = self.dataSource.someArray.reversed()
            refreshControl.endRefreshing()
        }
    }
    
    deinit {
        print(self.classForCoder)
    }
}
