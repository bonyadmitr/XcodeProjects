//
//  InfiniteController.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 16/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// Examples of InfiniteScrolling realiations
/// https://github.com/icodesign/ICSPullToRefresh.Swift/blob/master/ICSPullToRefresh/ICSInfiniteScrolling.swift
/// https://github.com/LeoMobileDeveloper/PullToRefreshKit/blob/master/Source/Classes/Footer.swift
class InfiniteController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataSource = TableDataSource()
    var isLoadingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.tableView = tableView
        tableView.tableFooterView = getInfinityView()
    }
    
    func getInfinityView() -> UIView {
        let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
        let activity = UIActivityIndicatorView(frame: rect)
        activity.startAnimating()
        activity.color = UIColor.red
        return activity
    }
    
    private var page = 1
    func loadMore() {
        if isLoadingMore {
            return
        }
        isLoadingMore = true
        DispatchQueue.main.asyncAfter(deadline: globalPullToRefreshDelay) {
            self.page += 1
            if self.page <= 5 {
                self.dataSource.someArray.append(1111)
                /// stopLoadingMore
            } else {
                /// noticeNoMoreData
                self.tableView.tableFooterView = nil
            }
            self.isLoadingMore = false
        }
    }
    
    deinit {
        print(self.classForCoder)
    }
    
}

extension InfiniteController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let infinity = tableView.tableFooterView?.bounds.height ?? 0
        let deltaOffset = maximumOffset - currentOffset - infinity
        
        if deltaOffset <= 0 {
            loadMore()
        }
    }
}
