//
//  AboutController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 18/10/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class AboutController: UIViewController {
    
    private enum RawType {
        case feedback
        case privacyPolicy
        case rateApp
        case appStorePage
        case developerPage
    }
    
    private let cellId = String(describing: DetailCell.self)
    private let raws: [RawType] = [.feedback, .privacyPolicy, .rateApp, .appStorePage, .developerPage]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.register(AboutHeader.self, forHeaderFooterViewReuseIdentifier: "AboutHeader")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        /// need for iOS 10, don't need for iOS 11
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
        
        title = L10n.about
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        deselectRowIfNeed()
//    }
    
    /// need for iOS 11(maybe others too. iOS 10 don't need) split controller, opened in landscape with large text accessibility
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
//    private func deselectRowIfNeed() {
//        if let indexPath = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//    }
    
    private func sendFeedback() {
        EmailSender.shared.send(message: "",
                                subject: NonL10n.emailTitle,
                                to: [EmailSender.devEmail],
                                presentIn: self)
    }
}

// MARK: - UIViewControllerRestoration
extension AboutController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        assert(String(describing: self) == identifierComponents.last, "unexpected restoration path: \(identifierComponents)")
        return AboutController(coder: coder)
    }
}

// MARK: - UITableViewDataSource
extension AboutController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return raws.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "AboutHeader")
    }
}

// MARK: - UITableViewDelegate
extension AboutController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? DetailCell else {
            assertionFailure()
            return
        }
        
        let raw = raws[indexPath.row]
        
        switch raw {
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
            cell.accessoryType = .disclosureIndicator
            cell.setup(title: L10n.moreAppsFromMe)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? AboutHeader else {
            assertionFailure()
            return
        }
        
        header.label.text = L10n.settings
        header.imageView.image = #imageLiteral(resourceName: "ic_settings")
        header.versionLabel.text = UIApplication.shared.version
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let raw = raws[indexPath.row]

        switch raw {
        case .feedback:
            sendFeedback()
        case .privacyPolicy:
            let vc = PrivacyPolicyController()
            navigationController?.pushViewController(vc, animated: true)
        case .rateApp:
            RateAppManager.googleApp.rateInAppOrRedirectToStore()
        case .appStorePage:
            RateAppManager.googleApp.openAppStorePage()
        case .developerPage:
            let vc = DeveloperAppsController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
