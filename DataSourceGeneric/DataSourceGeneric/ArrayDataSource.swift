//
//  ArrayDataSource.swift
//  DataSourceGeneric
//
//  Created by Bondar Yaroslav on 20/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ArrayDataSource<CellType: UITableViewCell, ItemType>  {
    
    private weak var tableView: UITableView!
    
    var items: [ItemType] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
        self.tableView.dataSource = proxy
    }
    
    
    private var cellReuseIdentifier = String(describing: CellType.self)
    
    private lazy var proxy: DataSourceProxy = {
        return DataSourceProxy(
            numberOfItems: {[unowned self] in self.numberOfRowsInSection($0) },
            cellForItem: {[unowned self] in self.tableView($0, cellForRowAt: $1) })
    }()
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                 for: indexPath) as! FillableCell<ItemType>
        cell.fill(with: items[indexPath.row])
        return cell
    }
}

//    var configureClosure: (CellType, ItemType) -> Void = { (cell, item) in
//        guard let cell = cell as? FillableCell<ItemType> else {
//            return print("CellType is not FillableCell")
//        }
//        cell.fill(with: item)
//    }

/// 1
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CellType
//        configureClosure(cell, items[indexPath.row])





//lazy var dataSource: ArrayDataSource<SomeCell, SomeEntity> = {
//    let ds = ArrayDataSource<SomeCell, SomeEntity>()
//    ds.configureClosure = { cell, item in
//        cell.fill(with: item)
//    }
//    ds.tableView = self.tableView
//    return ds
//}()
