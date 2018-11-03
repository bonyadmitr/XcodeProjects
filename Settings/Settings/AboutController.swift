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
        tableView.rowHeight = UITableViewAutomaticDimension
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
        
        title = "About".localized
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
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
                                subject: "Feedback",
                                to: [EmailSender.devEmail],
                                presentIn: self)
    }
}

// MARK: - UIViewControllerRestoration
extension AboutController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        assert(String(describing: self) == (identifierComponents.last as? String), "unexpected restoration path: \(identifierComponents)")
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
        let raw = raws[indexPath.row]
        
        switch raw {
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
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "More apps from me"
        }
        
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        /// need only for iOS 9 and 10. don't need for iOS 11
        cell.textLabel?.numberOfLines = 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? AboutHeader else {
            assertionFailure()
            return
        }
        
        view.label.text = "Settings app"
        view.imageView.image = #imageLiteral(resourceName: "ic_settings")
        view.versionLabel.text = UIApplication.shared.version
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

final class AboutHeader: UITableViewHeaderFooterView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
//        if #available(iOS 11.0, *) {
//            safeAreaLayoutGuide.topAnchor
//            directionalLayoutMargins
//        } else {
//        }
        
        /// addSubview before activate constraints
        addSubview(label)
        addSubview(versionLabel)
        addSubview(imageView)
        
        let constant: CGFloat = 8
        
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        /// defailt constraint priority is 1000
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
        //imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //imageView.setContentCompressionResistancePriority(UILayoutPriority(100), for: .vertical)
        //layoutMargins.bottom
        
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: constant).isActive = true
        label.bottomAnchor.constraint(equalTo: versionLabel.topAnchor, constant: -constant).isActive = true
        label.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        
        versionLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        versionLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        versionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constant).isActive = true
        versionLabel.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}
