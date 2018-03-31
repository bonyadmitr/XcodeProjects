//
//  ICSController.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 16/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import ICSPullToRefresh

/// https://github.com/icodesign/ICSPullToRefresh.Swift
/// deinit not called
class ICSController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataSource = TableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.tableView = tableView
        tableView.addPullToRefreshHandler {
            DispatchQueue.main.asyncAfter(deadline: globalPullToRefreshDelay) {
                print("refreshData")
                self.dataSource.someArray = self.dataSource.someArray.reversed()
                self.tableView.pullToRefreshView?.stopAnimating()
            }
        }
    }
    
    deinit {
        print(self.classForCoder)
    }
}
