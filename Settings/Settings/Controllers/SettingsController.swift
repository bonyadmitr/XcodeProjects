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
        case appStorePage
        case developerPage
        case about
    }
    
    private let sections = [Section(type: .language,
                                    raws: [.select, .appearance]),
                            Section(type: .support,
                                    raws: [/*.privacyPolicy, .appStorePage, .developerPage,*/
                                        .feedback, .rateApp, .about])]
    
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
        
        //removeBackButtonTitle()
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
        case .appStorePage:
            cell.accessoryType = .none
            cell.textLabel?.text = "Open in App Store"
        case .developerPage:
            cell.accessoryType = .none
            cell.textLabel?.text = "More apps from me"
        case .about:
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "About"
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
            push(controller: LanguageSelectController())
        case .appearance:
            push(controller: AppearanceSelectController())
        case .feedback:
            sendFeedback()
        case .privacyPolicy:
            push(controller: PrivacyPolicyController())
        case .rateApp:
            RateAppManager.googleApp.rateInAppOrRedirectToStore()
        case .appStorePage:
            RateAppManager.googleApp.openAppStorePage()
        case .developerPage:
            DeveloperAppsManager.shared.openDeveloperAppStorePage(devId: "id281956209")
        case .about:
            push(controller: AboutController())
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
