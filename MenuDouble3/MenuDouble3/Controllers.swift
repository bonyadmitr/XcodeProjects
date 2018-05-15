//
//  Controllers.swift
//  MenuDouble
//
//  Created by Bondar Yaroslav on 14/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class RightMenuController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuDoubleController?.delegates.add(delegate: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        menuDoubleController?.delegates.remove(delegate: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

extension RightMenuController: MenuDoubleDelegate {
    func leftMenuOpening(progress: CGFloat, type: ProgressType) {
        switch type {
        case .moving:
            tableView.alpha = 1 - progress
        case .finish:
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1 - progress
            }
        }
    }
}

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

class TableViewController: UITableViewController {
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.isEditing = true
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}
