//
//  ViewController.swift
//  QRScreenScanner
//
//  Created by Bondar Yaroslav on 7/23/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    enum TableColumns: String {
        case date
        case value
        case action
        
        var title: String {
            switch self {
            case .date:
                return " Date"
            case .value:
                return " Value"
            case .action:
                return " Action"
            }
        }
    }
    
    private var tableDataSource = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
//        addTableView()
        
//        if #available(OSX 10.13, *) {
//            let q = DropView(frame: view.bounds)
//            q.autoresizingMask = [.width, .height]
//            view.addSubview(q)
//        }
        
        
        tableDataSource = HistoryDataSource.shared.history
        reloadDataSource()
        
        HistoryDataSource.shared.didChanged = { [weak self] newHistoryDataSource in
            guard let self = self else {
                return
            }
            self.tableDataSource = newHistoryDataSource
            self.reloadDataSource()
        }
    }
    
    override func loadView() {
        let frame = CGRect(x: 0, y: 0, width: 500, height: 300)
        if #available(OSX 10.13, *) {
            let view = DropView2(frame: frame)
            view.setup(ext: ["jpg", "jpeg", "bmp", "png", "gif"]) { filePath in
                print(filePath)
            }
            
            self.view = view
        } else {
            view = NSView(frame: frame)
        }
    }
    
    private func reloadDataSource() {
        tableDataSource.sort(sortDescriptors: tableView.sortDescriptors)
        tableView.reloadData()
    }
    
    private let tableView = NSTableView()
    
    private func addTableView() {
        /// https://stackoverflow.com/a/27747282/5893286
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")])
        
        /// https://stackoverflow.com/a/55495391/5893286
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Copy", action: #selector(tableViewCopyItemClicked), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Delete", action: #selector(tableViewDeleteItemClicked), keyEquivalent: ""))
        tableView.menu = menu
        
        /// https://stackoverflow.com/a/30262248/5893286
//        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
//        tableView.sizeLastColumnToFit()
        
        
        let button = NSButtonCell(imageCell: NSImage(named: NSImage.revealFreestandingTemplateName))
        //button.setButtonType(.momentaryPushIn)
        button.bezelStyle = .circular
        button.title = ""
        button.action = #selector(actionButtonCell)
        button.target = self
        
        let column3 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: TableColumns.action.rawValue))
        column3.dataCell = button
        column3.width = 40
        column3.title = TableColumns.action.title
        tableView.addTableColumn(column3)
        
        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: TableColumns.date.rawValue))
        column1.isEditable = false
        column1.width = 100
        column1.minWidth = 50
        column1.maxWidth = 200
        column1.title = TableColumns.date.title
        tableView.addTableColumn(column1)
        
        /// call before tableView.addTableColumn
        let allWithoutLastColumnsWidth: CGFloat = tableView.tableColumns.reduce(0, { $0 + $1.width })
        /// 3 or 6 is magic number. + 1 for new column
        let separatorsWidth = CGFloat((tableView.tableColumns.count + 1) * 3) // 6
        
        let column2 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: TableColumns.value.rawValue))
        column2.width = view.bounds.width - allWithoutLastColumnsWidth - separatorsWidth
        column2.isEditable = false
        column2.title = TableColumns.value.title
        tableView.addTableColumn(column2)
        
        /// first add all columns programmatically and then setup autosave
        tableView.autosaveName = "historyTableView"
        tableView.autosaveTableColumns = true
        
        /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/TableView/SortingTableViews/SortingTableViews.html
        let dateSortDescriptor = NSSortDescriptor(key: #keyPath(History.date), ascending: false)
        let valueSortDescriptor = NSSortDescriptor(key: #keyPath(History.value), ascending: true)
        tableView.sortDescriptors = [dateSortDescriptor, valueSortDescriptor]
        column1.sortDescriptorPrototype = dateSortDescriptor
        column2.sortDescriptorPrototype = valueSortDescriptor
        
        let tableContainer = NSScrollView(frame: view.bounds)
        tableContainer.autoresizingMask = [.width, .height]
        tableContainer.documentView = tableView
        tableContainer.hasVerticalScroller = true
        view.addSubview(tableContainer)
    }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
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
            let date = tableDataSource[row].date
            return dateFormatter.string(from: date)
        case .value:
            return tableDataSource[row].value
        case .action:
            return nil
        }
    }
    
    @objc private func actionButtonCell(_ button: NSButtonCell) {
        print(tableView.selectedRow)
        
        let text = tableDataSource[tableView.selectedRow].value
        
        if let url = URL(string: text) {
            NSWorkspace.shared.open(url)
        } else if let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "https://www.google.com/search?q=\(encodedText)")
        {
            NSWorkspace.shared.open(url)
        } else {
            let alert = NSAlert()
            alert.messageText = "Unable to open \(text)"
            alert.runModal()
        }
    }
    
    @objc private func tableViewCopyItemClicked(_ sender: AnyObject) {
        
        guard tableView.clickedRow >= 0 else {
            return
        }
        
        let text = tableDataSource[tableView.selectedRow].value
        
        // TODO: test set declareTypes one time
        /// https://stackoverflow.com/a/34902953/5893286
        //NSPasteboard.general.clearContents()
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        NSPasteboard.general.setString(text, forType: NSPasteboard.PasteboardType.string)
    }
    
    @objc private func tableViewDeleteItemClicked(_ sender: AnyObject) {
        
        guard tableView.clickedRow >= 0 else {
            return
        }
        
        tableDataSource.remove(at: tableView.clickedRow)
        HistoryDataSource.shared.history = tableDataSource
        tableView.reloadData()
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        reloadDataSource()
    }
    
//    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
//        return nil
//    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        guard let board = info.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board.firstObject as? String
        else {
            return []
        }
        
        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in ["jpg", "jpeg", "bmp", "png", "gif"] {
            if ext.lowercased() == suffix {
                return .copy
            }
        }
        return []
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        
        guard let pasteboard = info.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        //GET YOUR FILE PATH !!!
        print("FilePath: \(path)")
        
        return true
    }
}

extension MutableCollection where Self: RandomAccessCollection, Element: NSObject {
    
    /// https://stackoverflow.com/a/42313342/5893286
    /// Sort `self` in-place using criteria stored in a NSSortDescriptors array
    public mutating func sort(sortDescriptors theSortDescs: [NSSortDescriptor]) {
        sort { by:
            for sortDesc in theSortDescs {
                switch sortDesc.compare($0, to: $1) {
                case .orderedAscending: return true
                case .orderedDescending: return false
                case .orderedSame: continue
                }
            }
            return false
        }
    }
}

//extension Array {
//
//    /// https://stackoverflow.com/a/34973936/5893286
//    public mutating func sort(sortDescriptors theSortDescs: [NSSortDescriptor]) {
//        if let tempArray = (self as NSArray).sortedArray(using: theSortDescs) as? [Element] {
//            self = tempArray
//        } else {
//            assertionFailure()
//        }
//    }
//}

@available(OSX 10.10, *)
final class CodeDetector {
    
    static let shared = CodeDetector()
    
    /// native
    func readQR(from image: NSImage) -> [String] {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            assertionFailure("cgImage convert problem")
            return []
        }
        return readQR(from: cgImage)
    }
    
    func readQR(from image: CGImage) -> [String] {
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                     context: nil,
                                     options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        else {
            assertionFailure("nil in simulator, A7 core +")
            return []
        }
        
        let ciImage = CIImage(cgImage: image)
        
        guard let features = detector.features(in: ciImage) as? [CIQRCodeFeature] else {
            assertionFailure("CIDetector(ofType is different")
            return []
        }
        
        return features.compactMap({$0.messageString})
    }
}
