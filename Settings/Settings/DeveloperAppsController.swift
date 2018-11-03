//
//  DeveloperAppsController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class DeveloperAppsController: UIViewController {
    
    private struct Section {
        let type: SectionType
        let raws: [RawType]
    }
    
    private enum SectionType {
        case installed
        case newApps
        case emptyTitle
    }
    
    private enum RawType {
        case installedApp
        case newApp
        case developerPage
    }
    
    private var sections: [Section] = []
    private var apps: SchemeAppTuple = ([],[])
    private let cellId = String(describing: DetailCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        /// need for iOS 10, don't need for iOS 11
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
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
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
        
        /// if you set title in viewDidLoad(loadView too), it will not be set in language changing
        title = "Developer Apps".localized
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        updateApps()
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
        
        if !apps.newApps.isEmpty {
            let raws = Array<RawType>(repeating: .newApp, count: apps.newApps.count)
            let section = Section(type: .newApps, raws: raws)
            newSections.append(section)
        }
        
        if !apps.installedApps.isEmpty {
            let raws = Array<RawType>(repeating: .installedApp, count: apps.installedApps.count)
            let section = Section(type: .installed, raws: raws)
            newSections.append(section)
        }
        
        let section = Section(type: .emptyTitle, raws: [.developerPage])
        newSections.append(section)
        
        sections = newSections
        /// don't work with AppearanceConfigurator
        //tableView.reloadData()
    }
}

// MARK: - UIViewControllerRestoration
extension DeveloperAppsController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        assert(String(describing: self) == (identifierComponents.last as? String), "unexpected restoration path: \(identifierComponents)")
        return DeveloperAppsController(coder: coder)
    }
}

// MARK: - UITableViewDataSource
extension DeveloperAppsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].raws.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension DeveloperAppsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let raw = sections[indexPath.section].raws[indexPath.row]
        
        switch raw {
        case .installedApp:
            let app = apps.installedApps[indexPath.row]
            cell.textLabel?.text = app.name
        case .newApp:
            let app = apps.newApps[indexPath.row]
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
        case .installedApp:
            let app = apps.installedApps[indexPath.row]
            try? UIApplication.shared.open(scheme: app.scheme)
        case .newApp:
            let app = apps.newApps[indexPath.row]
            RateAppManager(appId: app.appStoreId).openAppStorePage()
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
