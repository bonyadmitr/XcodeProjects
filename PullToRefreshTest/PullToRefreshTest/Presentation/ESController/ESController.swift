//
//  ESController.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 16/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import ESPullToRefresh

//UITableView+Scroll
extension UITableView {
    func scrollToBottom() {
        let sections = numberOfSections
        let rows = numberOfRows(inSection: sections - 1)
        let indexPath = IndexPath(row: rows - 1, section: sections - 1)
        scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

/// https://github.com/eggswift/pull-to-refresh
/// Stop refresh when your job finished, it will reset refresh footer if completion is true
/// self?.tableView.es_stopPullToRefresh(ignoreDate: true)
/// Set ignore footer or not
/// self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
class ESController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataSource = TableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.tableView = tableView
        
        let pullAnimator = ESRefreshHeaderAnimator(frame: .zero)
        tableView.es_addPullToRefresh(animator: pullAnimator)  { [weak self] in
            self?.refresh()
        }
        
        let infiniteAnimator = ESRefreshFooterAnimator.init(frame: .zero)
        self.tableView.es_addInfiniteScrolling(animator: infiniteAnimator) { [weak self] in
            self?.loadMore()
        }
        
        /// es_autoPullToRefresh
//        self.tableView.refreshIdentifier = String(describing: self)
//        self.tableView.expriedTimeInterval = 5
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.tableView.es_autoPullToRefresh()
//        }
    }
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: globalPullToRefreshDelay) {
            print("refreshData")
            self.dataSource.someArray = self.dataSource.someArray.reversed()
            self.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
        }
    }
    
    private var page = 1
    func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: globalPullToRefreshDelay) {
            self.page += 1
            if self.page <= 5 {
                self.dataSource.someArray.append(1111)
                self.tableView.es_stopLoadingMore()
            } else {
                self.tableView.es_noticeNoMoreData()
            }
        }
    }
    
    deinit {
        print(self.classForCoder)
    }
}
