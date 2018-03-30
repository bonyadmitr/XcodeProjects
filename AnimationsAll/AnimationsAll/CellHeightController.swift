//
//  CellHeightController.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 06/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

import UIKit

class CellHeightCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

/// Multiple
class CellHeightController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellHeightCell
        cell.titleLabel?.text = "  \(indexPath.row + 1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.indexPathsForSelectedRows?.contains(indexPath) == true ? 200 : 40
    }
}

/// 1 cell
class CellHeightController2: UITableViewController {
    
    var selectedIndex = -1
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellHeightCell
        cell.titleLabel?.text = "  \(indexPath.row + 1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == selectedIndex ? 200 : 40
    }
}

