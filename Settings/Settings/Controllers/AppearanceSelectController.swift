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
        let cellId = String(describing: DetailCell.self)
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let cellId = String(describing: DetailCell.self)
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
        title = L10n.appearance
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
//        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        /// need for iOS 10, don't need for iOS 11
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
//        if #available(iOS 10.0, *) {
//            if let previousTraitCollection = previousTraitCollection,
//                previousTraitCollection.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory,
//                traitCollection.preferredContentSizeCategory == .accessibilityExtraLarge ||
//                    traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraLarge || 
//                    traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraExtraLarge
//            {
//                UIView.performWithoutAnimation {
//                    self.tableView.beginUpdates()
//                    self.tableView.endUpdates()
//                }
//            }
//        }
    }
}

extension AppearanceSelectController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        assert(String(describing: self) == identifierComponents.last, "unexpected restoration path: \(identifierComponents)")
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
        guard let cell = cell as? DetailCell else {
            assertionFailure()
            return
        }
        
        if themes[indexPath.row] == AppearanceConfigurator.shared.currentTheme {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.selectionStyle = .none
        cell.setup(title: themes[indexPath.row].name)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        VibrationManager.shared.mediumVibrate()
        
        if themes[indexPath.row] == AppearanceConfigurator.shared.currentTheme {
//            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        /// fixing of UILable instant color change
        /// otherwise will be need "cell.selectionStyle = .none"
//        tableView.deselectRow(at: indexPath, animated: false)
        
        /// fixing of UILable instant color change
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AppearanceConfigurator.shared.applyAndSaveCurrent(theme: self.themes[indexPath.row])
            tableView.reloadData()
        }
    }
}
