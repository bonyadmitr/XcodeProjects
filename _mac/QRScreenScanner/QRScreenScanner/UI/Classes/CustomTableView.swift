import Cocoa

protocol CustomTableViewDelegate: class {
    func didCopy()
    func didDelete()
    func didEnter()
}

// TODO: handle enter button 
final class CustomTableView: NSTableView {
    
    private var deleteAction: Selector?
    private var deleteTarget: Any?
    
    var customDelegate: CustomTableViewDelegate?
//    var customDelegate: (CustomTableViewDelegate & QLPreviewPanelDataSource)?
    
    func setDelete(action: Selector?, target: Any?) {
        self.deleteAction = action
        self.deleteTarget = target
    }
    
    /// https://stackoverflow.com/a/42489007
    override func menu(for event: NSEvent) -> NSMenu? {
        let location = convert(event.locationInWindow, from: nil)
        let selectedRow = row(at: location)
        
        if selectedRow == -1 {
            return nil
        } else {
            return super.menu(for: event)
        }
    }
    
    /// modifierFlags switch https://stackoverflow.com/a/32447474/5893286
    /// NSDeleteCharacter https://github.com/bazelbuild/tulsi/blob/master/src/Tulsi/OptionsEditorController.swift
    override func keyDown(with event: NSEvent) {
        
        guard let character = event.charactersIgnoringModifiers?.first?.unicodeScalars.first, let customDelegate = customDelegate else {
            assertionFailure("\(event.charactersIgnoringModifiers ?? "nil"), \(self.customDelegate == nil)")
            super.keyDown(with: event)
            return
        }
        
        /// to prevent open https://www.orange.es/ by space key
        if character == " " {
//            togglePreviewPanel()
            return
        }
        
        /// Enter key
        //if event.keyCode == 36 {
        if character == "\r" {
            customDelegate.didEnter()
            return
        }
        
//        switch event.keyCode {
//        case 49: // Space
//            togglePreviewPanel()
//        case 123, 124, 125, 126: // Left, Right, Up, Down
//            outlineView.keyDown(with: event)
//            QLPreviewPanel.shared().reloadData()
        
        if character == UnicodeScalar(NSDeleteCharacter)
            || character == UnicodeScalar(NSBackspaceCharacter)
            || character == UnicodeScalar(NSDeleteFunctionKey) // fn+delete
            || character == UnicodeScalar(NSDeleteCharFunctionKey)
        {
            customDelegate.didDelete()
        } else {
            super.keyDown(with: event)
        }
        
        //if event.charactersIgnoringModifiers?.first == Character(UnicodeScalar(NSDeleteCharacter)!) {
        
        //        if let deleteAction = deleteAction,
        //            event.charactersIgnoringModifiers == String(format: "%c", NSDeleteCharacter),
        //            selectedRow != -1
        //        {
        //            NSApp.sendAction(deleteAction, to: deleteTarget, from: self)
        //            /// super.keyDown(with: event) not called to disable error sound
        //        } else {
        //            super.keyDown(with: event)
        //        }
    }
    
    /// NSTextView.copy(_:)
    @objc private func copy(_ sender: AnyObject?) {
        customDelegate?.didCopy()
    }
    
    /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MenuList/Articles/EnablingMenuItems.html
    override func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        //print(item)
        if item.action == #selector(NSTextView.copy(_:)) {
            return !selectedRowIndexes.isEmpty
        }
        return super.validateUserInterfaceItem(item)
    }
    
//    private func togglePreviewPanel() {
//        if QLPreviewPanel.sharedPreviewPanelExists() && QLPreviewPanel.shared().isVisible {
//            QLPreviewPanel.shared().orderOut(nil)
//        } else {
//            if dataSource?.numberOfRows?(in: self) == 0 {
//                return
//            }
//            //            if selectedRowIndexes.isEmpty {
//            //                return
//            //            }
//            QLPreviewPanel.shared().makeKeyAndOrderFront(nil)
//        }
//    }
//
//    override func acceptsPreviewPanelControl(_: QLPreviewPanel!) -> Bool {
//        return true
//    }
//
//    var previewPanel: QLPreviewPanel?
//
//
//    override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
//        panel.delegate = self
//        panel.dataSource = customDelegate
//        previewPanel = panel
//    }
//
//    override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
//        previewPanel = nil
//        panel.dataSource = nil
//        panel.delegate = nil
//    }
}

//extension CustomTableView: QLPreviewPanelDelegate {
//    func previewPanel(_: QLPreviewPanel!, handle event: NSEvent!) -> Bool {
//        guard event.type == .keyDown else { return false }
//        keyDown(with: event)
//        return true
//    }
//
//    /// import Quartz.QuickLookUI
//    /// sourceFrameOnScreenFor https://github.com/GiorgiaAuroraAdorni/dct2-compression/blob/master/FasterThanLightFourierTransform/FasterThanLightFourierTransform/ImageView.swift
//    /// keyDown https://github.com/maku693/RightSide/blob/master/RightSide/ViewController.swift
//    /// search https://github.com/search?l=Swift&p=2&q=QLPreviewPanel&type=Code
//
//    //    func previewPanel(_: QLPreviewPanel!, sourceFrameOnScreenFor _: QLPreviewItem!) -> NSRect {
//    //        guard let cell = outlineView.view(atColumn: outlineView.selectedColumn,
//    //                                          row: outlineView.selectedRow,
//    //                                          makeIfNecessary: false) as? NSTableCellView
//    //            else { return .zero }
//    //        let cellRectOnWindow = cell.convert(cell.imageView?.frame ?? .zero, to: nil)
//    //        guard view.frame.contains(cellRectOnWindow) else { return .zero }
//    //        return cell.window!.convertToScreen(cellRectOnWindow)
//    //    }
//
//    //    func previewPanel(_: QLPreviewPanel!,
//    //                      transitionImageFor item: QLPreviewItem!,
//    //                      contentRect _: UnsafeMutablePointer<NSRect>!) -> Any! {
//    //        guard let entry = item as? DirectoryEntry else { return nil }
//    //        return entry.image
//    //    }
//}
