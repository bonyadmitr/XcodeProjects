//
//  MasterController.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class MasterController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
    }
    
}

extension MasterController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    }
}

extension MasterController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let cell = cell as? UITableViewCell else {
//            return
//        }
        //cell.fill(with: )
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MasterController: UISplitViewControllerDelegate {
    
    //  iPhone??
    
    //    func splitViewController(
    //        _ splitViewController: UISplitViewController,
    //        collapseSecondary secondaryViewController: UIViewController,
    //        onto primaryViewController: UIViewController) -> Bool
    //    {
    //        return true
    //    }
    
    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        switch svc.displayMode {
        case .allVisible:
            return .primaryHidden
        case .primaryHidden:
            return .allVisible
        case .primaryOverlay, .automatic:
            return .allVisible
        }
    }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        
    }
}
