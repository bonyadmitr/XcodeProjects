//
//  MasterController.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class MasterController: UIViewController {
    
    @IBOutlet weak var tableView: MasterTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        splitViewController?.delegate = self
        
        splitViewController?.preferredDisplayMode = .allVisible
        
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.updateSelectedRowOnViewWillAppear()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in
            self.tableView.updateSelectedRowOnViewWillTransition()
        }
    }

    
    /// UNSAFE !!!
    private func setupInitialState() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        
        for vc in splitViewController?.viewControllers ?? [] {
            if let secondaryVC = vc.rootIfNavOrSelf as? DetailController, let cell = tableView.cellForRow(at: indexPath) {
                secondaryVC.text = cell.textLabel?.text
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail",
            let vc = segue.destination.rootIfNavOrSelf as? DetailController,
            let indexPath = sender as? IndexPath,
            let cell = tableView.cellForRow(at: indexPath)
        {
            vc.text = cell.textLabel?.text
        }
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "1", modifierFlags: .command, action: #selector(selectTab), discoverabilityTitle: "Types"),
            UIKeyCommand(input: "2", modifierFlags: .command, action: #selector(selectTab), discoverabilityTitle: "Protocols"),
            UIKeyCommand(input: "3", modifierFlags: .command, action: #selector(selectTab), discoverabilityTitle: "Functions"),
            UIKeyCommand(input: "4", modifierFlags: .command, action: #selector(selectTab), discoverabilityTitle: "Operators"),
            
            UIKeyCommand(input: "f", modifierFlags: [.command, .alternate], action: #selector(selectTab), discoverabilityTitle: "Find…"),
        ]
    }
    
    @objc private func selectTab(_ sender: UIKeyCommand) {
        let selectedTab = sender.input
        // ...
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
        
        performSegue(withIdentifier: "detail", sender: indexPath)
        //navigationController
    }
}

extension MasterController: UISplitViewControllerDelegate {
    
    /// if "return true" will show master instead of detail on the phone after turn from landscape to portrait orientation
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        /// if nothing selected on iPhone+ in portrait, will show master vc after turned to the landscape
        if tableView.indexPathForSelectedRow == nil {
            return true
        }
        return false
    }
    
    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        switch svc.displayMode {
        case .primaryHidden:
            return .allVisible
        case .allVisible, .primaryOverlay, .automatic:
            return .primaryHidden
        }
    }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        
    }
}

