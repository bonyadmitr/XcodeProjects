//
//  ClearableTableSelection.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// not so usefull
protocol ClearableTableSelection {
    var tableView: UITableView! { get }
    func clearsSelectionOnViewWillAppear()
}

extension ClearableTableSelection where Self: UIViewController {
    func clearsSelectionOnViewWillAppear() {
        guard
            UI_USER_INTERFACE_IDIOM() == .phone,
            let selectedIndexPath = tableView.indexPathForSelectedRow
        else {
            return
        }
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            tableView.deselectRow(at: selectedIndexPath, animated: true)
            
            /// there is a bug
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            splitViewController?.showDetailViewController(vc, sender: nil)
            
        default:
            break
        }
    }
}

/// without splitViewController
//extension UITableView {
//    /// in UITableViewController use ".clearsSelectionOnViewWillAppear = true"
//    func clearsSelectionOnViewWillAppear() {
//        if UI_USER_INTERFACE_IDIOM() == .phone, let selectedIndexPath = indexPathForSelectedRow {
//            switch UIDevice.current.orientation {
//            case .portrait, .portraitUpsideDown:
//                deselectRow(at: selectedIndexPath, animated: true)
//            default:
//                break
//            }
//        }
//    }
//}
