//
//  ViewController.swift
//  DataSourceGeneric
//
//  Created by Bondar Yaroslav on 20/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var dataSource: ArrayDataSource<SomeCell, SomeEntity> = {
        return ArrayDataSource<SomeCell, SomeEntity>(self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.items = [SomeEntity.random(), SomeEntity.random()]
    }
}

/// can be added configureClosure with default imp for cell delegate



/// 0
//extension ViewController: UITableViewDataSource {
//
//    var items: [SomeEntity] = [] // items = [SomeEntity.random(), SomeEntity.random()]
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SomeCell
//        cell.fill(with: object)
//        return cell
//    }
//}


//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        /// 1
//        dataSource.items = [SomeEntity.random(), SomeEntity.random()]
//
//        /// 2
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.dataSource.items = (1...40).map {_ in return SomeEntity.random()}
//        }
//
//        /// 3
//        tableView.delegate = self
//    }


/// 3
//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        print(dataSource.items[indexPath.row].title)
//    }
//}

/// 4
///service




