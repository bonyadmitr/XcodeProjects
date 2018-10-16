//
//  SettingsController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class SettingsController: UIViewController, BackButtonActions {
    
    private struct Section {
        let type: SectionType
        let raws: [RawType]
    }
    
    private enum SectionType {
        case language
        case support
    }
    
    private enum RawType {
        case select
        case appearance
        case feedback
        case privacyPolicy
        case rateApp
    }
    
    private let sections = [Section(type: .language,
                                    raws: [.select, .appearance]),
                            Section(type: .support,
                                    raws: [.feedback, .privacyPolicy, .rateApp])]
    
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
        extendedLayoutIncludesOpaqueBars = true
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
            detailVC.title = vc.title
        }
    }
    
    private func sendFeedback() {
        EmailSender.shared.send(message: "",
                                subject: "Settings feedback",
                                to: [EmailSender.devEmail],
                                presentIn: self)
    }
    
    /// need for iOS 11(maybe others too. iOS 10 don't need) split controller, opened in landscape with large text accessibility
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

extension SettingsController: UITableViewDataSource {
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

extension SettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let raw = sections[indexPath.section].raws[indexPath.row]
        
        switch raw {
        case .select:
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "language".localized
        case .appearance:
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "appearance".localized
        case .feedback:
            cell.accessoryType = .none
            cell.textLabel?.text = "Send feedback"
        case .privacyPolicy:
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Privacy Policy"
        case .rateApp:
            cell.accessoryType = .none
            cell.textLabel?.text = "Rate Us"
        }
        
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        //cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        /// need only for iOS 9 and 10. don't need for iOS 11
        cell.textLabel?.numberOfLines = 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let raw = sections[indexPath.section].raws[indexPath.row]
        
        switch raw {
        case .select:
            performSegue(withIdentifier: "detail", sender: LanguageSelectController())
        case .appearance:
            performSegue(withIdentifier: "detail", sender: AppearanceSelectController())
        case .feedback:
            sendFeedback()
        case .privacyPolicy:
            performSegue(withIdentifier: "detail", sender: PrivacyPolicyController())
        case .rateApp:
            RateAppManager.shared.rateApp()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        
        switch section.type {
        case .language:
            return "language".localized
        case .support:
            return "support".localized
        }
    }
}


import StoreKit

typealias BoolHandler = (Bool) -> Void

final class RateAppManager {
    
     /// google appId for example
    static let shared = RateAppManager(appId: "id284815942")
    
    private let appId: String
    
    init(appId: String) {
        self.appId = appId
    }
    
    /// open app page in AppStore
    func openAppStorePage(completion: BoolHandler?) {
        //let urlPath = "itms-apps://itunes.apple.com/ru/app/cosmeteria/\(appId)"
        let urlPath = "itms-apps://itunes.apple.com/app/\(appId)"
        openURL(string: urlPath, completion: completion)
    }
    
    /// open app review page in AppStore
    /// appId should look like "idXXXXXXXXXX"
    /// https://stackoverflow.com/questions/27755069/how-can-i-add-a-link-for-a-rate-button-with-swift
    /// "mt=8&" can be added after "?"
    func rateAppByRedirectToStore(completion: BoolHandler?) {
        /// will be trigered in simulator by safary.
        /// from apple example code.
        let urlPath = "https://itunes.apple.com/app/\(appId)?action=write-review"
        
        /// will not be trigered in simulator
        //let urlPath = "itms-apps://itunes.apple.com/app/\(appId)?action=write-review"
        
        openURL(string: urlPath, completion: completion)
    }
    
    private func openURL(string: String, completion: BoolHandler?) {
        guard let url = URL(string: string) else {
            completion?(false)
            assertionFailure()
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        } else {
            completion?(UIApplication.shared.openURL(url))
        }
    }
}

extension RateAppManager {
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            /// google example
            rateAppByRedirectToStore(completion: nil)
        }
    }
}
