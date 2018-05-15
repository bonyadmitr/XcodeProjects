//
//  DataSourceProxy.swift
//  DataSourceGeneric
//
//  Created by Bondar Yaroslav on 21/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class DataSourceProxy: NSObject {
    var numberOfItems: (Int) -> Int
    var cellForItem: (UITableView, IndexPath) -> UITableViewCell
    
    init(numberOfItems: @escaping (Int) -> Int,
         cellForItem: @escaping (UITableView, IndexPath) -> UITableViewCell) {
        self.numberOfItems = numberOfItems
        self.cellForItem = cellForItem
    }
}

extension DataSourceProxy: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForItem(tableView, indexPath)
    }
}
