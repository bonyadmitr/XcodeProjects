//
//  YalantisController.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 16/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import PullToRefresh

/// https://github.com/Yalantis/PullToRefresh
/// deinit not called
class YalantisController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataSource = TableDataSource()
    let refresher = PullToRefresh()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.tableView = tableView
        tableView.addPullToRefresh(refresher) {
            DispatchQueue.main.asyncAfter(deadline: globalPullToRefreshDelay) {
                print("refreshData")
                self.dataSource.someArray = self.dataSource.someArray.reversed()
                self.tableView.endRefreshing(at: .top)
            }
        }
        
    }
    
    deinit {
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
        print(self.classForCoder)
    }
}
