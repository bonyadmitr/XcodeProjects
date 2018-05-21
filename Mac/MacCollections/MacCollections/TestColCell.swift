//
//  TestColCell.swift
//  MacCollections
//
//  Created by zdaecqze zdaecq on 15.08.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Cocoa

protocol TestColCellDelegate: class {
    func didClickOnOk(index: Int, cell: TestColCell)
}

class TestColCell: NSCollectionViewItem {
    
    @IBOutlet weak var backView: NSView!
    @IBOutlet weak var titile: NSTextField!
    
    var index: Int?
    weak var delegate: TestColCellDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.wantsLayer = true
        backView.layer?.cornerRadius = 10
        backView.layer?.backgroundColor = NSColor.redColor().CGColor
    }
    
    @IBAction func okButton(sender: NSButton) {
        guard let index = index else { return }
        delegate?.didClickOnOk(index, cell: self)
    }
}