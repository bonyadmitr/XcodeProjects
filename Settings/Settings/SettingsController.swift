//
//  SettingsController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class SettingsController: UIViewController, BackButtonActions {
    
    private enum Section: Int {
        case language = 0
        
        static let count = 1
        
        enum LanguageRaws: Int {
            case select = 0
            case appearance
            
            static let count = 2
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
        }
    }
    
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
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "ic_settings"), selectedImage: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeBackButtonTitle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" || segue.identifier == "detail!",
            let vc = sender as? UIViewController,
            let navVC = segue.destination as? UINavigationController,
            let detailVC = navVC.topViewController as? SplitDetailController
        {
            detailVC.childVC = vc
        }
    }
}

extension SettingsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            assertionFailure()
            return 0
        }
        switch section {
        case .language: return Section.LanguageRaws.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    }
}

extension SettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            assertionFailure()
            return
        }
        
        switch section {
        case .language:
            guard let row = Section.LanguageRaws(rawValue: indexPath.row) else {
                assertionFailure()
                return
            }
            
            switch row {
            case .select:
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "language".localized
            case .appearance:
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "appearance".localized
            }
            
            cell.textLabel?.textColor = AppearanceConfigurator.shared.currentTheme.textColor
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(rawValue: indexPath.section) else {
            assertionFailure()
            return
        }
        
        switch section {
        case .language:
            guard let row = Section.LanguageRaws(rawValue: indexPath.row) else {
                assertionFailure()
                return
            }
            
            switch row {
            case .select:
                performSegue(withIdentifier: "detail", sender: LanguageSelectController())
//                let vc = LanguageSelectController()
//                navigationController?.pushViewController(vc, animated: true)
            case .appearance:
                performSegue(withIdentifier: "detail", sender: AppearanceSelectController())
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else {
            assertionFailure()
            return nil
        }
        
        switch section {
        case .language:
            return "language".localized
        }
    }
}
