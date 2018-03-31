//
//  PullToRefreshKitController.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 16/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import PullToRefreshKit

/// https://github.com/LeoMobileDeveloper/PullToRefreshKit
class PullToRefreshKitController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataSource = TableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.tableView = tableView
        
        _ = tableView.setUpHeaderRefresh { [weak self] in
            self?.refresh()
        }.SetUp { header in
            header.setText("Pull to refresh", mode: .pullToRefresh)
            header.setText("Release to refresh", mode: .releaseToRefresh)
            header.setText("Success", mode: .refreshSuccess)
            header.setText("Refreshing...", mode: .refreshing)
            header.setText("Failed", mode: .refreshFailure)
            header.textLabel.textColor = UIColor.orange
//            header.imageView.image = nil
        }
        _ = self.tableView.setUpFooterRefresh { [weak self] in
            self?.loadMore()
        }
    }
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: globalPullToRefreshDelay) {
            print("refreshData")
            self.dataSource.someArray = self.dataSource.someArray.reversed()
//            self.tableView.endHeaderRefreshing()
            self.tableView.endHeaderRefreshing(.success, delay: 0.1)
        }
    }
    
    private var page = 1
    func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: globalPullToRefreshDelay) {
            self.page += 1
            if self.page <= 5 {
                self.dataSource.someArray.append(1111)
                self.tableView.endFooterRefreshing()
            } else {
                self.tableView.endFooterRefreshingWithNoMoreData()
            }
        }
    }
    
    deinit {
        print(self.classForCoder)
    }
}
