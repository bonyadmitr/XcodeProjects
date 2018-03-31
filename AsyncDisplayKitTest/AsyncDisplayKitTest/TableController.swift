//
//  TableController.swift
//  AsyncDisplayKitTest
//
//  Created by zdaecqze zdaecq on 28.08.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class TableController: UIViewController {
    
    

    var tableView: ASTableView!
    
    var array = [Item]()
    
    var randomString: String {
        
        let randomNumber = Int(arc4random_uniform(20))
        var res = ""
        for _ in 0..<randomNumber {
            res += "W"
        }
        return res
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<100 {
            let item = Item(title: "i = \(i)\n\(randomString)", time: NSDate(), jobType: "Const")
            array.append(item)
        }
        
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 64)
        tableView = ASTableView(frame: rect)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.allowsSelection = false
        tableView.asyncDataSource = self
        tableView.asyncDelegate = self
        view.addSubview(tableView)
        //tableView.reloadData()
        
        
    }
    @IBAction func editTableBarButton(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.editing, animated: true)
    }

}

extension TableController: ASTableDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        let cell = TableCell(item: array[indexPath.row])
        
        return cell
    }
}

extension TableController: ASTableViewDelegate {
    
    
}
