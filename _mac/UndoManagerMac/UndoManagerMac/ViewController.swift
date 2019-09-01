//
//  ViewController.swift
//  UndoManagerMac
//
//  Created by Bondar Yaroslav on 9/1/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// window is not shown yet
        assert(NSApp.keyWindow == nil && undoManager == nil)
        
        /// undoManager will not register action
        //setObject(value: "1")
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        /// window is shown
        assert(NSApp.keyWindow != nil && undoManager != nil)
        setObject(value: "1")
    }
    
    var some = "0" {
        didSet {
            print(some)
        }
    }
    
    @objc func setObject(value: String) {
        /// or #1
        //undoManager?.registerUndo(withTarget: self, selector: #selector(setObject(value:)), object: some)
        
        /// or #2
        undoManager?.registerUndo(withTarget: self, handler: { [old = some] this in
            this.setObject(value: old)
        })
        
        undoManager?.setActionName("Delete")
        
        some = value
    }
    
}
