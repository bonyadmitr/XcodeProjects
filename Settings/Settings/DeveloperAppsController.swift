//
//  DeveloperAppsController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class DeveloperAppsController: UIViewController, BackButtonActions {
    
    private struct Section {
        let name: String
        let type: SectionType
        let apps: [SchemeApp]
    }
    
    private enum SectionType {
        case language
        case support
    }
    
    private let sections = [Section(name: "availableApps", type: .language, apps: DeveloperAppsManager.shared.apps.availableApps),
                            Section(name: "unavailableApps", type: .support, apps: DeveloperAppsManager.shared.apps.unavailableApps)]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let cellId = String(describing: UITableViewCell.self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        /// if you set title in viewDidLoad(loadView too), it will not be set in language changing
        title = "settings".localized
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeBackButtonTitle()
        
        view.addSubview(tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" || segue.identifier == "detail!",
            let vc = sender as? UIViewController,
            let navVC = segue.destination as? UINavigationController,
            let detailVC = navVC.topViewController as? SplitDetailController
        {
            detailVC.childVC = vc
            detailVC.title = vc.title
        }
    }
    
    /// need for iOS 11(maybe others too. iOS 10 don't need) split controller, opened in landscape with large text accessibility
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    private func sendFeedback() {
        EmailSender.shared.send(message: "",
                                subject: "Settings feedback",
                                to: [EmailSender.devEmail],
                                presentIn: self)
    }
    
    private func push(controller: UIViewController) {
        performSegue(withIdentifier: "detail", sender: controller)
    }
}

extension DeveloperAppsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count //+1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 2 {
//            return 1
//        }
        return sections[section].apps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    }
}

extension DeveloperAppsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let app = sections[indexPath.section].apps[indexPath.row]
        cell.textLabel?.text = app.name
        
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        /// need only for iOS 9 and 10. don't need for iOS 11
        cell.textLabel?.numberOfLines = 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let app = sections[indexPath.section].apps[indexPath.row]
        try? UIApplication.shared.open(scheme: app.scheme)
        
        
        //DeveloperAppsManager.shared.openDeveloperAppStorePage(devId: "id281956209")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        
        switch section.type {
        case .language:
            return "Installed".localized
        case .support:
            return "New apps".localized
        }
    }
}
