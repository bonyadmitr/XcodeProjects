//
//  ViewController.swift
//  MacCollections
//
//  Created by zdaecqze zdaecq on 15.08.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var tokenFiled: NSTokenField!
    
    var items = [String]()
    var items2 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = ["qwe", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef"]
        
        items2 = ["qwe", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef", "123", "dsfdgfhdgjghjfghjvfgudfhn", "werwef"]
        
        tableView.setDataSource(self)
        tableView.setDelegate(self)
        collectionView.dataSource = self
        collectionView.delegate = self
        tokenFiled.setDelegate(self)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.makeViewWithIdentifier("cell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = items[row]
            return cell
        }
        return nil
    }
    
}


extension ViewController: NSTableViewDelegate {
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        print(items[row])
        items.removeAtIndex(row)
        let index = NSIndexSet(index: row)
        
        tableView.beginUpdates()
        tableView.removeRowsAtIndexes(index, withAnimation: .SlideRight)
        tableView.endUpdates()
        
        return false
    }
}


extension ViewController: NSCollectionViewDataSource {
    
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items2.count
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        
        let cell = collectionView.makeItemWithIdentifier("TestColCell", forIndexPath: indexPath) as! TestColCell
        cell.titile.stringValue = items2[indexPath.item]
        cell.index = indexPath.item
        cell.delegate = self
        return cell
    }
}

extension ViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width - 10, height: 50)
    }
}

extension ViewController: TestColCellDelegate {
    func didClickOnOk(index: Int, cell: TestColCell) {
        print(items2[index])
        //print(tokenFiled.objectValue)
        self.items2.removeAtIndex(index)
        collectionView.reloadData()
        
        //let indexPath = NSIndexPath(forItem: index, inSection: 0)
        //let indexPathSet = Set(arrayLiteral: indexPath)
        //collectionView.performBatchUpdates({
            
            //self.collectionView.deleteItemsAtIndexPaths(indexPathSet)
            //}, completionHandler: nil)
    }
}

extension ViewController: NSTokenFieldDelegate {
    //func tokenField(tokenField: NSTokenField, completionsForSubstring substring: String, indexOfToken tokenIndex: Int, indexOfSelectedItem selectedIndex: UnsafeMutablePointer<Int>) -> [AnyObject]? {
        
        //return [substring]
    //}
    
    //func tokenField(tokenField: NSTokenField, representedObjectForEditingString editingString: String) -> AnyObject {
    
    //}
}




