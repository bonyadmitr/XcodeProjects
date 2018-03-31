//
//  TableDataSource.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 15/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

var globalPullToRefreshDelay: DispatchTime {
    return .now() + 2
}

class TableDataSource: NSObject {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet { tableView.dataSource = self }
    }
    
    var someArray: [Int] = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1] {
        didSet { tableView.reloadData() }
    }
}
extension TableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return someArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(someArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section + 1)"
    }
}
