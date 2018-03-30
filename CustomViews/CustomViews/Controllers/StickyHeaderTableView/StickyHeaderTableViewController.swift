//
//  StickyHeaderTableViewController.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 16.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class StickyHeaderTableViewController: UITableViewController {
    
    let rowNumber = 30
    var table: StickyHeaderTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table = tableView as! StickyHeaderTableView
        table.headerMinHeight = 50
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.updateHeaderView()
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        table.updateHeaderView()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNumber
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Row " + String(indexPath.row + 1)
        return cell
    }
}
