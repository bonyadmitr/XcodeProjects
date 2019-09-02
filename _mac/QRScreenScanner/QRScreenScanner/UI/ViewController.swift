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
    
    private let tableView = CustomTableView()
    private var tableDataSource = [History]()
    
    private let statusLabel: NSTextField = {
        let newValue = NSTextField()
        newValue.isEditable = false
        newValue.isSelectable = false
        newValue.stringValue = "No data"
        return newValue
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    override func loadView() {
        let frame = CGRect(x: 0, y: 0, width: 500, height: 300)
        view = NSView(frame: frame)
    }
    
    deinit {
        undoManager?.removeAllActions(withTarget: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView()
        setupHistoryDataSource()
        
        /// call the last to add view on the top
        addDropView()
        
        assert(NSApp.keyWindow == nil && undoManager == nil)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        /// NSApp.keyWindow != nil after window.makeKeyAndOrderFront
        assert(NSApp.keyWindow != nil && undoManager != nil)
        
//        let deleteMenuItem = App.shared.menuManager.deleteMenuItem
//        deleteMenuItem.action = #selector(tableViewDeleteItemClicked)
//        deleteMenuItem.target = self
        
//        let selectAllMenuItem = App.shared.menuManager.selectAllMenuItem
//        selectAllMenuItem.action = #selector(NSTableView.selectAll)
//        selectAllMenuItem.target = tableView
        
//        becomeFirstResponder()
    }
    
//    @objc func copy1() {
//
//    }
    
    private func addTableView() {
        /// https://stackoverflow.com/a/27747282/5893286
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        tableView.doubleAction = #selector(actionButtonCell)
        tableView.setDelete(action: #selector(tableViewDeleteItemClicked), target: self)
        tableView.customDelegate = self
//        tableView.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")])
        
        /// use zebra like row colors, like in finder
        tableView.usesAlternatingRowBackgroundColors = true
        
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
        
        let tableContainer = NSScrollView()
        tableContainer.documentView = tableView
        tableContainer.hasVerticalScroller = true
        
        view.addSubview(tableContainer)
        view.addSubview(statusLabel)
        
        //if #available(OSX 10.11, *) {
        tableContainer.translatesAutoresizingMaskIntoConstraints = false
        tableContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableContainer.bottomAnchor.constraint(equalTo: statusLabel.topAnchor).isActive = true
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupHistoryDataSource() {
        self.updateTableView(with: HistoryDataSource.shared.history)
        
        /// subscribe on changes
        HistoryDataSource.shared.didChanged = { [weak self] newHistoryDataSource in
            guard let self = self else {
                return
            }
            self.updateTableView(with: newHistoryDataSource)
        }
    }
    
    private func updateTableView(with newHistoryDataSource: [History]) {
        tableDataSource = newHistoryDataSource
        reloadDataSource()
        updateStatusLabel()
    }
    
    private func reloadDataSource() {
        tableDataSource.sort(sortDescriptors: tableView.sortDescriptors)
        tableView.reloadData()
    }
    
    /// call the last to add view on the top
    private func addDropView() {
        let dropView = DropView(frame: view.bounds)
        dropView.setup(isSubview: true, fileTypes: NSImage.imageTypes) { filePaths, images in
            QRService.scanFiles(at: filePaths)
            QRService.scanImages(images)
        }
        dropView.autoresizingMask = [.width, .height]
        view.addSubview(dropView)
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
            let date = tableDataSource[row].date
            return dateFormatter.string(from: date)
        case .value:
            return tableDataSource[row].value
        case .action:
            return nil
        }
    }
    
    @objc private func actionButtonCell() {
        
        guard tableView.selectedRow >= 0 else {
            print("double click in empty table")
            return
        }
        
        tableView.selectedRowIndexes
            .compactMap { tableDataSource[$0].value }
            .forEach { openInBrowser(text: $0) }
    }
    
    private func openInBrowser(text: String) {
        if (text.hasPrefix("http://") || text.hasPrefix("https://")), let url = URL(string: text) {
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
    
    @objc private func tableViewCopyItemClicked(_ sender: AnyObject?) {
        let copiedText: String
        
        if tableView.clickedRow >= 0 {
            if tableView.selectedRowIndexes.contains(tableView.clickedRow) {
                copiedText = tableView.selectedRowIndexes
                    .compactMap { tableDataSource[$0].value }
                    .joined(separator: "\n")
            } else {
                copiedText = tableDataSource[tableView.clickedRow].value
            }
            
        } else {
            copiedText = tableView.selectedRowIndexes
                .compactMap { tableDataSource[$0].value }
                .joined(separator: "\n")
        }

        
        // TODO: test set declareTypes one time
        /// https://stackoverflow.com/a/34902953/5893286
        NSPasteboard.general.clearContents()
        
        /// doc: This method is the equivalent of invoking clearContents()...
        NSPasteboard.general.declareTypes([.string], owner: nil)
        
        NSPasteboard.general.setString(copiedText, forType: .string)
        
        //NSPasteboard.general.writeObjects([copiedText as NSPasteboardWriting])
    }
    
    @objc func tableViewDeleteItemClicked() {
        
        let isSomethingSelected = tableView.clickedRow >= 0 || tableView.selectedRow >= 0
        guard isSomethingSelected else {
            NSSound.playError()
            return
        }
        
        if tableView.clickedRow >= 0 {
            if tableView.selectedRowIndexes.contains(tableView.clickedRow) {
                tableDataSource.remove(at: tableView.selectedRowIndexes)
                
                if tableView.selectedRowIndexes.count > 1 {
                    tableView.deselectAll(nil)
                }
            } else if tableView.clickedRow >= 0 {
                tableDataSource.remove(at: tableView.clickedRow)
            }
        } else {
//            undoManager?.registerUndo(withTarget: self, handler: { [old = tableDataSource] self1 in
//                self1.tableDataSource = old
//                HistoryDataSource.shared.history = old
//                self1.tableView.reloadData()
//
//                self1.undoManager?.registerUndo(withTarget: self, handler: { [old2 = old] self2 in
//                    self2.tableDataSource = old2
//                    HistoryDataSource.shared.history = old2
//                    self2.tableView.reloadData()
//                })
//                self1.undoManager?.setActionName("Restore")
//
//            })
//            undoManager?.setActionName("Delete")
            
            tableDataSource.remove(at: tableView.selectedRowIndexes)
            if tableView.selectedRowIndexes.count > 1 {
                tableView.deselectAll(nil)
            }
        }
        
        setupNewTableDataSource(tableDataSource)
//        HistoryDataSource.shared.history = tableDataSource
//        tableView.reloadData()
    }
    
    private func setupNewTableDataSource(_ tableDataSource: [History]) {
//        undoManager?.registerUndo(withTarget: self, handler: { [old2 = tableDataSource] self2 in
//            self2.tableDataSource = old2
//            HistoryDataSource.shared.history = old2
//            self2.tableView.reloadData()
//        })
//        undoManager?.setActionName("Delete")
        undoManager?.registerUndo(withTarget: self, handler: { [old = HistoryDataSource.shared.history] unownedSelf in
            unownedSelf.setupNewTableDataSource(old)
            unownedSelf.undoManager?.setActionName("Restore")
        })
        undoManager?.setActionName("Delete")
        
        HistoryDataSource.shared.history = tableDataSource
        tableView.reloadData()
    }
    
    @objc private func tableViewSelectAll() {
//        tableView.selectAll(nil)
    }
}

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        reloadDataSource()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateStatusLabel()
    }
    
    private func updateStatusLabel() {
        let itemsSelected = tableView.selectedRowIndexes.count
        let text: String
        
        if tableDataSource.isEmpty {
            text = "No Items"
        } else if itemsSelected == 0 {
            text = "\(tableDataSource.count) items"
        } else {
            text = "\(itemsSelected) of \(tableDataSource.count) selected"
        }
        
        statusLabel.stringValue = text
    }
}

extension ViewController: CustomTableViewDelegate {
    func didPaste() {
        
        /// from finder
//        Optional([[__C.NSPasteboardType(_rawValue: public.file-url), __C.NSPasteboardType(_rawValue: com.apple.icns), __C.NSPasteboardType(_rawValue: public.utf16-external-plain-text), __C.NSPasteboardType(_rawValue: public.utf8-plain-text)]])
        
        /// google chrome, copy image
//["public.tiff", "public.html"]
        // copy address, copy link
//        public.utf8-plain-text
        
        /// safari
//Optional([["public.tiff", "dyn.ah62d4rv4gu8zs3pcnzme2641rf4guzdmsv0gn64uqm10c6xenv61a3k", "dyn.ah62d4rv4gu8yc6durvwwaznwmuuha2pxsvw0e55bsmwca7d3sbwu", "public.url", "public.url-name", "public.utf8-plain-text", "com.apple.flat-rtfd", "com.apple.webarchive"]])
        // copy address, copy link
//        ["dyn.ah62d4rv4gu8zs3pcnzme2641rf4guzdmsv0gn64uqm10c6xenv61a3k", "dyn.ah62d4rv4gu8yc6durvwwaznwmuuha2pxsvw0e55bsmwca7d3sbwu", "public.url", "public.url-name", "public.utf8-plain-text"]
        
        
        /// finder
//        - 0 : "public.file-url"
//        - 1 : "com.apple.icns"
//        - 2 : "public.utf16-external-plain-text"
//        - 3 : "public.utf8-plain-text"
        
        //NSPasteboard.general.data(forType: .fileURL)
//        let data = NSPasteboard.general.data(forType: .backwardsCompatibleFileURL)!
//        print( String(data: data, encoding: .utf8) )
        
        //print(NSPasteboard.general.pasteboardItems?.compactMap { $0.types.compactMap{ $0.rawValue} })
//        print(NSPasteboard.general.pasteboardItems?.compactMap { $0.types.compactMap{ $0.rawValue} })
//
//        guard let items = NSPasteboard.general.pasteboardItems else {
//            return
//        }
//
//        for item in items {
//
//        }
//        NSPasteboard.general.readObjects(forClasses: <#T##[AnyClass]#>, options: <#T##[NSPasteboard.ReadingOptionKey : Any]?#>)
        
        let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes: NSImage.imageTypes]
        
        guard
            let urls = NSPasteboard.general.readObjects(forClasses: [NSURL.self],
                                                             options: filteringOptions) as? [URL],
            let images = NSPasteboard.general.readObjects(forClasses: [NSImage.self],
                                                               options: filteringOptions) as? [NSImage]
        else {
            assertionFailure()
            return
        }
        
        //"public.utf8-plain-text"
        //NSPasteboard.PasteboardType(kUTTypeUTF8PlainText as String)
        
//        NSPasteboard.general.pasteboardItems!.first!.types
//        NSPasteboard.general.pasteboardItems?.compactMap { $0.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text") ) }
        //NSPasteboard.general.pasteboardItems!.first!.types.compactMap { $0.rawValue }
        
        //assert(!urls.isEmpty || !images.isEmpty, "one item must exists here. filtered by isAllowedDraging")
        let filePaths = urls.map { $0.path }
        //print(filePaths.count, images.count)
        QRService.scan(filesAt: filePaths, images: images)
//        QRService.scanFiles(at: filePaths)
//        QRService.scanImages(images)
        
//        let urls = NSPasteboard.general.pasteboardItems?.compactMap { $0.string(forType: .backwardsCompatibleFileURL) }
//        let urls2 = NSPasteboard.general.pasteboardItems?.compactMap { $0.data(forType: .tiff) }
////        NSPasteboard.general.pasteboardItems?.compactMap { $0.string(forType: NSPasteboard.PasteboardType(kUTTypeImage as String)) }
//        print(urls)
//        print(urls2)
    }
    
    func didCut() {
        tableViewCopyItemClicked(nil)
        tableViewDeleteItemClicked()
    }
    
    func didEnter() {
        actionButtonCell()
    }
    
    func didCopy() {
        tableViewCopyItemClicked(nil)
        //        guard let selectedItems = messageArrayController.selectedObjects as? [NSPasteboardWriting], !selectedItems.isEmpty else {
        //            return
        //        }
        //
        //        let pasteboard = NSPasteboard.general
        //        pasteboard.clearContents()
        //        pasteboard.writeObjects(selectedItems)
    }
    
    func didDelete() {
        tableViewDeleteItemClicked()
    }
}

/// needs import Quartz.QuickLookUI
//extension ViewController: QLPreviewPanelDataSource {
//    func numberOfPreviewItems(in _: QLPreviewPanel!) -> Int {
//        return 1//tableDataSource.count //dataSource?.numberOfRows?(in: self) ?? 0
//    }
//
//    func previewPanel(_: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
//        //let text = tableDataSource[index].value
//        let text = tableDataSource[tableView.selectedRow].value
//
//        if (text.hasPrefix("http://") || text.hasPrefix("https://")), let url = URL(string: text) {
//            return url as QLPreviewItem
//        } else if let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
//            let url = URL(string: "https://www.google.com/search?q=\(encodedText)")
//        {
//            return url as QLPreviewItem
//        } else {
//            return nil
//        }
//        //return //activeObjects[index] as? DirectoryEntry
//    }
//}
