//
//  ManualController.swift
//  DynamicCell
//
//  Created by Bondar Yaroslav on 17/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ManualController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataSource = TableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.tableView = tableView
    }
    
    var heightsCache: [IndexPath: CGFloat] = [:]
}

extension ManualController: UITableViewDelegate {
    
    /// And if the tableview has a lot of rows, you should return an approximate value for height in estimatedHeightForRowAtIndexPath to speed up the loading process of the view controller
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /// was 21 calculations without cache for iPhone 5s
        /// with it only 5 times (dataSource.someArray.count)
        /// and will caculate for every new display cell
        if let height = heightsCache[indexPath] {
            return height
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let font = cell.titleLabel.font!
        let width = cell.bounds.width
        
        let title = "Title"
        let titleHeight = title.height(forWidth: width, font: font) // can be optimized with: = 20.287109375
        let body = dataSource.someArray[indexPath.row]
        let bodyHeight = body.height(forWidth: width, font: font)
        
        let height = titleHeight + bodyHeight + TableViewCell.insets
        heightsCache[indexPath] = height
        print(indexPath)
        return height
    }
}
