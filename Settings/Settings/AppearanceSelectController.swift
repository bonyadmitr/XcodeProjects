//
//  AppearanceSelectController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 28/09/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class AppearanceSelectController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let cellId = String(describing: UITableViewCell.self)
    private let themes = AppearanceConfigurator.themes
    private let appearanceConfigurator = AppearanceConfigurator.shared
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        title = "appearance".localized
        restorationIdentifier = String(describing: AppearanceSelectController.self)
        restorationClass = AppearanceSelectController.self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
//        appearanceConfigurator.register(self)
    }
}

extension AppearanceSelectController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        return AppearanceSelectController(coder: coder)
    }
}

extension AppearanceSelectController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
}

extension AppearanceSelectController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if themes[indexPath.row] == AppearanceConfigurator.shared.currentTheme {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = themes[indexPath.row].name
        cell.textLabel?.textColor = AppearanceConfigurator.shared.currentTheme.textColor
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if themes[indexPath.row] == AppearanceConfigurator.shared.currentTheme {
            return
        }
        
        /// without recreation needs reloadData
        tableView.reloadData()
        
        AppearanceConfigurator.shared.apply(theme: themes[indexPath.row])
    }
}

extension AppearanceSelectController: AppearanceConfiguratorDelegate {
    func didApplied(theme: AppearanceTheme) {
//        tableView.backgroundColor = theme.backgroundColor
    }
}
