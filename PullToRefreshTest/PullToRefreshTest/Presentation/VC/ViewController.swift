//
//  ViewController.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 11/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// for iOS 9.3 there is a bug with section header
/// http://stackoverflow.com/questions/15233147/header-displaced-in-tableview-with-uirefreshcontrol
/// + https://www.youtube.com/watch?v=kEjJWfWKGSg
/// for iOS 10 with new property everything is correct
///
/// Когда отображается рефреш в таблицу добавляется contentInset сверху,
/// в scrollViewDidScroll отслеживать offset, если больше высоты рефреша,
/// убирать этот инсет. Соответственно при обратном скролле добавлять
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let dataSource = TableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.tableView = tableView
        tableView.addRefreshControl(title: "Pull to refresh", color: .blue)
        tableView.refreshBlock = refreshData
    }
    
    lazy var refreshData: UIScrollView.RefreshBlock = { [weak self] refreshControl in
        guard let guardSelf = self else { return }
        DispatchQueue.main.asyncAfter(deadline: globalPullToRefreshDelay) {
            print("refreshData")
            guardSelf.dataSource.someArray = guardSelf.dataSource.someArray.reversed()
            refreshControl.endRefreshing()
        }
    }
    
    deinit {
        print(self.classForCoder)
    }
}
