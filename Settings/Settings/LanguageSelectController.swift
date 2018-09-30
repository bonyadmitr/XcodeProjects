//
//  LanguageSelectController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class LanguageSelectController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let cellId = String(describing: DetailCell.self)
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
//        tableView.register(DetailCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let cellId = String(describing: DetailCell.self)
    private let localizationManager = LocalizationManager.shared
    private let languageManager = LanguageManager.shared
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        title = "language".localized
        restorationIdentifier = String(describing: LanguageSelectController.self)
        restorationClass = LanguageSelectController.self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
}

extension LanguageSelectController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        return LanguageSelectController(coder: coder)
    }
}

extension LanguageSelectController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageManager.availableLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
}

extension LanguageSelectController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let language = languageManager.availableLanguages[indexPath.row]
        let languageDisplayName = languageManager.displayName(for: language)
        cell.textLabel?.text = languageDisplayName
        
        if language == localizationManager.currentLanguage {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
//        let englishDisplayName = languageManager.displayName(for: language, in: "en")
//        cell.detailTextLabel?.text = englishDisplayName
        if localizationManager.currentLanguage != "en" {
            let englishDisplayName = languageManager.displayName(for: language, in: "en")
            cell.detailTextLabel?.text = englishDisplayName
        } else {
            cell.detailTextLabel?.text = ""
        }
        
//        cell.textLabel?.textColor = AppearanceConfigurator.shared.currentTheme.textColor
//        cell.detailTextLabel?.textColor = AppearanceConfigurator.shared.currentTheme.textColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let language = languageManager.availableLanguages[indexPath.row]
        
        if language == localizationManager.currentLanguage {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        localizationManager.set(language: language)
    }
}

//private final class DetailCell: UITableViewCell {
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}
