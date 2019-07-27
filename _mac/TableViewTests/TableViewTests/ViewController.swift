//
//  ViewController.swift
//  TableViewTests
//
//  Created by Bondar Yaroslav on 7/27/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    enum TableColumns: String {
        case date
        case value
        
        var title: String {
            switch self {
            case .date:
                return "Date"
            case .value:
                return "Value"
            }
        }
    }
    
    private let tableDataSource: [[String: Any]] = [
        [TableColumns.date.rawValue: 1, TableColumns.value.rawValue: "qqqqqqq"],
        [TableColumns.date.rawValue: 2, TableColumns.value.rawValue: "aaaaaa"],
        [TableColumns.date.rawValue: 3, TableColumns.value.rawValue: "erwerwe"],
        [TableColumns.date.rawValue: 4, TableColumns.value.rawValue: "asdasdasdaspyoptyopd"],
        [TableColumns.date.rawValue: 5, TableColumns.value.rawValue: "ffds"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        addTableView()
        addTableViewByBinding()
    }
    
    private func addTableView() {
        /// https://stackoverflow.com/a/27747282/5893286
        let tableView = NSTableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        
        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: TableColumns.date.rawValue))
        column1.width = 100
        column1.title = TableColumns.date.title
        tableView.addTableColumn(column1)
        
        let column2 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: TableColumns.value.rawValue))
        column2.width = view.frame.width - 100
        column2.title = TableColumns.value.title
        tableView.addTableColumn(column2)
        
        
        let tableContainer = NSScrollView(frame: view.bounds)
        tableContainer.autoresizingMask = [.width, .height]
        tableContainer.documentView = tableView
        tableContainer.hasVerticalScroller = true
        view.addSubview(tableContainer)
    }
    
    private func addTableViewByBinding() {
        /// https://stackoverflow.com/a/27747282/5893286
        let tableView = NSTableView(frame: view.bounds)
        
        let arrayController = NSArrayController(content: tableDataSource)
        arrayController.content = tableDataSource
        
        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: TableColumns.date.rawValue))
        column1.width = 100
        column1.title = TableColumns.date.title
        
        column1.bind(.value,
                     to: arrayController,
                     withKeyPath: NSArrayController.keyPath(for: TableColumns.date.rawValue),
                     options: nil)
        tableView.addTableColumn(column1)
        
        let column2 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: TableColumns.value.rawValue))
        column2.width = view.frame.width - 100
        column2.title = TableColumns.value.title
        column2.bind(.value,
                     to: arrayController,
                     withKeyPath: NSArrayController.keyPath(for: TableColumns.value.rawValue),
                     options: nil)
        tableView.addTableColumn(column2)
        
        
        let tableContainer = NSScrollView(frame: view.bounds)
        tableContainer.autoresizingMask = [.width, .height]
        tableContainer.documentView = tableView
        tableContainer.hasVerticalScroller = true
        view.addSubview(tableContainer)
    }
}

extension NSArrayController {
    static func keyPath(for keyPath: String) -> String {
        return "\(#keyPath(NSArrayController.arrangedObjects)).\(keyPath)"
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableDataSource.count
    }
    
    /// NSTableView set content Mode
    /// https://stackoverflow.com/q/19218807/5893286
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard
            let columnIdentifier = tableColumn?.identifier.rawValue,
            let columnType = TableColumns(rawValue: columnIdentifier)
        else {
            assertionFailure(tableColumn?.identifier.rawValue ?? "tableColumn nil")
            return nil
        }
        
        switch columnType {
            
        case .date:
            return tableDataSource[row][TableColumns.date.rawValue]
        case .value:
            return tableDataSource[row][TableColumns.value.rawValue]
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
