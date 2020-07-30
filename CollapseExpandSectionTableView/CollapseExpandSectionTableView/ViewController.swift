//
//  ViewController.swift
//  CollapseExpandSectionTableView
//
//  Created by Bondar Yaroslav on 7/30/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 58
        tableView.allowsSelection = false
        return tableView
    }()
    
    let sctionData = [
        ["1"],
        ["1","2"],
        ["1","2","3"],
        ["1","2","3","4"],
        ["1","2","3","4","5"],
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }


}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sctionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sctionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sctionData[indexPath.section][indexPath.row]
        return cell
    }
    
}
