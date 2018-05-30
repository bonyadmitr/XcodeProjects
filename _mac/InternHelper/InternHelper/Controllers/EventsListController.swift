//
//  EventsListController.swift
//  InternHelper
//
//  Created by Yaroslav Bondar on 05.07.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Cocoa
import PromiseKit

// TODO: аналогично UsersListController
class EventsListController: NSWindowController {

    // MARK: - Properties
    @IBOutlet weak var tableView: NSTableView!
    var events : [Event] = []
    
    
    // MARK: - Life cycle
    override func windowDidLoad() {
        super.windowDidLoad()
        
        tableView.setDelegate(self)
        tableView.setDataSource(self)
    }
}


// MARK: - NSTableViewDelegate, NSTableViewDataSource
extension EventsListController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return events.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.makeViewWithIdentifier("EventCell", owner: nil) as? EventCell2 {
            cell.nameField?.stringValue = events[row].internId
            return cell
        }
        return nil
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let user = events[row]
        print(user.internId)
        return true
    }
}