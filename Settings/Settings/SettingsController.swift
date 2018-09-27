//
//  SettingsController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

import UIKit

final class DetailCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

final class LanguageSelectController: UIViewController {
    
    private let tableView = UITableView()
    private let cellId = String(describing: UITableViewCell.self)
    private let localizationManager = LocalizationManager.shared
    private let languageManager = LanguageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(tableView)
        
        tableView.register(DetailCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
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
        
        if localizationManager.currentLanguage != "en" {
            let englishDisplayName = languageManager.displayName(for: language, in: "en")
            cell.detailTextLabel?.text = englishDisplayName
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let language = languageManager.availableLanguages[indexPath.row]
        localizationManager.set(language: language)
    }
}

final class SettingsController: UIViewController {
    
    private enum Section: Int {
        case language = 0
        
        static let count = 1
        
        enum LanguageRaws: Int {
            case select = 0
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings".localized
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
        case .language: return 1
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
                cell.textLabel?.text = "Language".localized
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(rawValue: indexPath.section) else {
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
                let vc = LanguageSelectController()
                navigationController?.pushViewController(vc, animated: true)
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
            return "Language".localized
        }
    }
}
