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
        tableView.register(DetailCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let cellId = String(describing: UITableViewCell.self)
    private let localizationManager = LocalizationManager.shared
    private let languageManager = LanguageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        localizationManager.register(self)
        title = "language".localized
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
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let language = languageManager.availableLanguages[indexPath.row]
        
        if language == localizationManager.currentLanguage {
            return
        }
        
        localizationManager.set(language: language)
    }
}

extension LanguageSelectController: LocalizationManagerDelegate {
    func languageDidChange(to language: String) {
//        tableView.reloadData()
    }
}

private final class DetailCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
