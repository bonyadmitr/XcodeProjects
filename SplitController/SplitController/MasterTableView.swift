//
//  MasterTableView.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/8/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class MasterTableView: UITableView {
    
    private var lastSelectedIndexPath: IndexPath?
    
    func updateSelectedRowOnViewWillAppear() {
        guard
            UI_USER_INTERFACE_IDIOM() == .phone,
            let selectedIndexPath = indexPathForSelectedRow
        else {
            return
        }
        
        lastSelectedIndexPath = selectedIndexPath
        
        if UIDevice.current.orientation.isPortrait {
            deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func updateSelectedRowOnViewWillTransition() {
        guard
            UIDevice.current.orientation.isLandscape,
            UI_USER_INTERFACE_IDIOM() == .phone,
            let selectIndexPath = lastSelectedIndexPath
        else {
            return
        }
        selectRow(at: selectIndexPath, animated: false, scrollPosition: .middle)
    }
}
