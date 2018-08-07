//
//  MasterController.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIViewController {
    var contents: UIViewController {
        if let navVC = self as? UINavigationController {
            return navVC.visibleViewController ?? navVC
        } else {
            return self
        }
    }
}

// TODO: fix for iPhone+

class MasterController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
        
        setupInitialState()
    }
    
    /// UNSAFE
    private func setupInitialState() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }
        
        for vc in splitViewController?.viewControllers ?? [] {
            if let secondaryVC = vc.contents as? DetailController, let cell = tableView.cellForRow(at: indexPath) {
                secondaryVC.text = cell.textLabel?.text
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail",
            let vc = segue.destination.contents as? DetailController,
            let indexPath = sender as? IndexPath,
            let cell = tableView.cellForRow(at: indexPath)
        {
            vc.text = cell.textLabel?.text
        }
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
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        performSegue(withIdentifier: "detail", sender: indexPath)
    }
}

extension MasterController: UISplitViewControllerDelegate {
    
    //  iPhone??
    /// will show master instead detail on the phone
//    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
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
