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
        case vibration
        case sound
    }
    
    private let sections = [Section(type: .language,
                                    raws: [.select, .appearance, .vibration, .sound]),
                            Section(type: .support,
                                    raws: [/*.privacyPolicy, .appStorePage, .developerPage,*/
                                        .feedback, .rateApp, .about])]
    
    private lazy var settingsStorage: SettingsStorage = SettingsStorageImp.shared
    private var heightsCache: [IndexPath: CGFloat] = [:]
    private let cellId = String(describing: DetailCell.self)
    
    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
            let nib = UINib(nibName: cellId, bundle: nil)
            newValue.register(nib, forCellReuseIdentifier: cellId)
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
        title = L10n.settings
        tabBarItem = UITabBarItem(title: title, image: Images.icSettings, selectedImage: nil)
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// fix color during rotation
        AppearanceConfigurator.shared.register(self)
        didApplied(theme: AppearanceConfigurator.shared.currentTheme)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" || segue.identifier == "detail!",
            let vc = sender as? UIViewController,
            let navVC = segue.destination as? UINavigationController,
            let detailVC = navVC.topViewController as? SplitDetailController {
            detailVC.childVC = vc
            detailVC.title = vc.title
        }
    }
    
    /// need for iOS 11(maybe others too. iOS 10 don't need) split controller, opened in landscape with large text accessibility
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        heightsCache = [:]
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    private func sendFeedback() {
        EmailSender.shared.send(message: "",
                                subject: NonL10n.emailTitle,
                                to: [EmailSender.devEmail],
                                presentIn: self)
    }
    
    private func push(controller: UIViewController) {
        performSegue(withIdentifier: "detail", sender: controller)
    }
}

// MARK: - AppearanceConfiguratorDelegate
extension SettingsController: AppearanceConfiguratorDelegate {
    func didApplied(theme: AppearanceTheme) {
        view.backgroundColor = theme.backgroundColor
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
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
}

extension SettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? DetailCell else {
            assertionFailure()
            return
        }
        
        let raw = sections[indexPath.section].raws[indexPath.row]
        
        switch raw {
        case .select:
            cell.accessoryType = .disclosureIndicator
            cell.setup(title: L10n.language)
        case .appearance:
            cell.accessoryType = .disclosureIndicator
            cell.setup(title: L10n.appearance)
        case .feedback:
            cell.accessoryType = .none
            cell.setup(title: L10n.sendFeedback)
        case .privacyPolicy:
            cell.accessoryType = .disclosureIndicator
            cell.setup(title: L10n.privacyPolicy)
        case .rateApp:
            cell.accessoryType = .none
            cell.setup(title: L10n.rateUs)
        case .appStorePage:
            cell.accessoryType = .none
            cell.setup(title: L10n.openInAppStore)
        case .developerPage:
            cell.accessoryType = .none
            cell.setup(title: L10n.moreAppsFromMe)
        case .about:
            cell.accessoryType = .disclosureIndicator
            cell.setup(title: L10n.about)
        case .vibration:
            cell.setup(title: L10n.vibration)
            
            if settingsStorage.isEnabledVibration {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        case .sound:
            cell.setup(title: L10n.soundOnTap)
            
            if settingsStorage.isEnabledSounds {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
//        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
//        //cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
//
//        /// need only for iOS 9 and 10. don't need for iOS 11
//        cell.textLabel?.numberOfLines = 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        VibrationManager.shared.lightVibrate()
        SoundManager.shared.playTapSound()
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
        case .vibration:
            settingsStorage.isEnabledVibration.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        case .sound:
            settingsStorage.isEnabledSounds.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        
        switch section.type {
        case .language:
            return L10n.language
        case .support:
            return L10n.support
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightsCache[indexPath] {
            return height
        }

        /// not working. seem like recursion:
        //let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? DetailCell else {
            assertionFailure()
            return 0
        }
        
        /// fill cell with texts
        self.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        
        let height = cell.height()
        heightsCache[indexPath] = height
        return height
    }
}

// MARK: - UIStateRestoration
//extension SettingsController {
//
//    /// Constants for state restoration.
//    private static let restoreTableViewOffet = "restoreTableViewOffet"
//    private static let restoreSelectedIndexPath = "restoreSelectedIndexPath"
//
//    override func encodeRestorableState(with coder: NSCoder) {
//        super.encodeRestorableState(with: coder)
//
//        guard isViewLoaded else {
//            return
//        }
//
//        coder.encode(tableView.contentOffset, forKey: type(of: self).restoreTableViewOffet)
//        coder.encode(tableView.indexPathForSelectedRow, forKey: type(of: self).restoreSelectedIndexPath)
//    }
//
//    override func decodeRestorableState(with coder: NSCoder) {
//        super.decodeRestorableState(with: coder)
//        assert(isViewLoaded, "We assume the controller is never restored without loading its view first.")
//
//        let contentOffset = coder.decodeCGPoint(forKey: type(of: self).restoreTableViewOffet)
//        tableView.setContentOffset(contentOffset, animated: false)
//
//
//
////        let indexPath = coder.decodeObject(forKey: type(of: self).restoreSelectedIndexPath) as? IndexPath ?? IndexPath(row: 0, section: 0)
//        if let indexPath = coder.decodeObject(forKey: type(of: self).restoreSelectedIndexPath) as? IndexPath {
//            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
//        }
//    }
//}
