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
        let type: SectionType
        let raws: [RawType]
    }
    
    private enum RawType {
        case installed
        case newApp
        case developerPage
    }
    
    private enum SectionType {
        case installed
        case newApps
        case emptyTitle
    }
    
    private var sections: [Section] = []
    private var apps: (availableApps: [SchemeApp], unavailableApps: [SchemeApp]) = ([],[])
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateApps()
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
    
    private func updateApps() {
        var newSections: [Section] = []
        
        apps = DeveloperAppsManager.shared.apps
        
        if !apps.unavailableApps.isEmpty {
            let raws = Array<RawType>(repeating: .newApp, count: apps.availableApps.count)
            let section = Section(type: .newApps, raws: raws)
            newSections.append(section)
        }
        
        if !apps.availableApps.isEmpty {
            let raws = Array<RawType>(repeating: .installed, count: apps.availableApps.count)
            let section = Section(type: .installed, raws: raws)
            newSections.append(section)
        }
        
        let section = Section(type: .emptyTitle, raws: [.developerPage])
        newSections.append(section)
        
        sections = newSections
        tableView.reloadData()
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
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].raws.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    }
}

extension DeveloperAppsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let raw = sections[indexPath.section].raws[indexPath.row]
        
        switch raw {
        case .installed:
            let app = apps.availableApps[indexPath.row]
            cell.textLabel?.text = app.name
        case .newApp:
            let app = apps.unavailableApps[indexPath.row]
            cell.textLabel?.text = app.name
        case .developerPage:
            cell.textLabel?.text = "More apps from me at App Store"
        }
        
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        /// need only for iOS 9 and 10. don't need for iOS 11
        cell.textLabel?.numberOfLines = 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let raw = sections[indexPath.section].raws[indexPath.row]
        
        switch raw {
        case .installed:
            let app = apps.availableApps[indexPath.row]
            try? UIApplication.shared.open(scheme: app.scheme)
        case .newApp:
            let app = apps.unavailableApps[indexPath.row]
            // TODO: open app store page
            try? UIApplication.shared.open(scheme: app.scheme)
        case .developerPage:
            DeveloperAppsManager.shared.openDeveloperAppStorePage(devId: "id281956209")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        
        switch section.type {
        case .installed:
            return "Installed".localized
        case .newApps:
            return "New apps".localized
        case .emptyTitle:
            return nil
        }
    }
}
