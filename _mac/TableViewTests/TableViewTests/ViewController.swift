//
//  ViewController.swift
//  TableViewTests
//
//  Created by Bondar Yaroslav on 7/27/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addTableView()
    }
    
    private func addTableView() {
        /// https://stackoverflow.com/a/27747282/5893286
        let tableView = NSTableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        
        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "date"))
        column1.width = 100
        column1.title = "Date"
        tableView.addTableColumn(column1)
        
        let column2 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "value"))
        column2.width = view.frame.width - 100
        column2.title = "Value"
        tableView.addTableColumn(column2)
        
        
        let tableContainer = NSScrollView(frame: view.bounds)
        tableContainer.autoresizingMask = [.width, .height]
        tableContainer.documentView = tableView
        tableContainer.hasVerticalScroller = true
        view.addSubview(tableContainer)
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 100
    }
    
    /// NSTableView set content Mode
    /// https://stackoverflow.com/q/19218807/5893286
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let columnIdentifier = tableColumn?.identifier.rawValue else {
            assertionFailure()
            return nil
        }
        
        switch columnIdentifier {
        case "date" :
            return "date \(row)"
        case "value":
            return "value \(row)"
        default:
            assertionFailure()
            return nil
        }
    }
    
//    func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
//        <#code#>
//    }
    
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        return nil
//    }
}

extension ViewController: NSTableViewDelegate {
    
}
