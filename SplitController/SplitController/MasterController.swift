//
//  MasterController.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class MasterController: UIViewController {
    
    @IBOutlet weak var tableView: MasterTableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private lazy var texts: [String] = (1...100).map { "Raw \($0)"}  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSplitController()
        setupInitialState()
    }
    
    private func setupSplitController() {
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
        
        guard let splitController = splitViewController as? SplitController else {
            return
        }
        splitController.register(self)
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
            if let secondaryVC = vc.rootIfNavOrSelf as? DetailController {
                secondaryVC.text = texts[0]
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail",
            let vc = segue.destination.rootIfNavOrSelf as? DetailController,
            let indexPath = sender as? IndexPath
        {
            vc.text = texts[indexPath.row]
        }
    }
}

extension MasterController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
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
        cell.textLabel?.text = texts[indexPath.row]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRaw(at: indexPath)
    }
    
    private func selectRaw(at indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath)
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

extension MasterController: SplitControllerKeyCommandDelegate {
    func didPressed(keyCommand: SplitControllerKeyCommand) {
        
        let row: Int
        switch keyCommand {
        case .one:
            row = 0
        case .two:
            row = 1
        case .three:
            row = 2
        case .four:
            row = 3
        case .f:
            return
        }
        
        let indexPath = IndexPath(row: row, section: 0)
        selectRaw(at: indexPath)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
}
