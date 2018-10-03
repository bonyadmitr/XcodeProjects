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
        restorationIdentifier = String(describing: type(of: self))
        extendedLayoutIncludesOpaqueBars = true
        
        /// The class specified here must conform to `UIViewControllerRestoration`,
        /// explained above. If not set, you'd get a second chance to create the
        /// view controller on demand in the app delegate.
        restorationClass = type(of: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
}

/*
 Note the extra protocol: This view controller is not initially created
 (before `application(_:willFinishLaunchingWithOptions:)` returns), so
 it may have to be created on demand for state restoration.
 */
extension LanguageSelectController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        assert(String(describing: self) == (identifierComponents.last as? String), "unexpected restoration path: \(identifierComponents)")
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
        guard let cell = cell as? DetailCell else {
            assertionFailure()
            return
        }
        
        let language = languageManager.availableLanguages[indexPath.row]
        let languageDisplayName = languageManager.displayName(for: language) ?? language
        
        let englishDisplayName: String?
        if localizationManager.currentLanguage != "en" {
            englishDisplayName = languageManager.displayName(for: language, in: "en")
        } else {
            englishDisplayName = nil
        }
        
        let cellIsChecked = language == localizationManager.currentLanguage
        
        /// call before setup method for correct accessibilityLabel
        cell.isChecked = cellIsChecked
        
        cell.setup(title: languageDisplayName, subtitle: englishDisplayName)
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
