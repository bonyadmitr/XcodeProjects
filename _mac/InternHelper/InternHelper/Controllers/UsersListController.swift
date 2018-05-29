//
//  UsersListController.swift
//  InternHelper
//
//  Created by Yaroslav Bondar on 05.07.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Cocoa
import PromiseKit

class UsersListController: NSWindowController {

    // MARK: - Properties
    @IBOutlet weak var tableView: NSTableView!
    // TODO: не хранить в контроллере, а создать класс для этого
    var users : [OCUser] = []
    
    
    // MARK: - Life cycle
    override func windowDidLoad() {
        super.windowDidLoad()

        tableView.setDelegate(self)
        tableView.setDataSource(self)
        OCAccountService.getAll().then { array -> Void in
            self.users = array
            self.tableView.reloadData()
        }.catchAndShow()
    }
}


// MARK: - NSTableViewDelegate, NSTableViewDataSource
extension UsersListController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return users.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

        // TODO: не знаю, если переиспользования ячеек на маке, но если есть, то использовать
        if let cell = tableView.makeViewWithIdentifier("Cell", owner: nil) as? NSTableCellView {
            // TODO: если увеличится объем данных, то создать класс ячейки и метод для ее заполнения
            cell.textField?.stringValue = users[row].fullName
            return cell
        }
        return nil
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        // TODO: доделать логику
        let user = users[row]
        print(user.fullName)
        return true
    }
}
