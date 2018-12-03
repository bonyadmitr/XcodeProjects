//
//  ShareOptionsController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 12/3/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ImageCell: UITableViewCell {
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let constant: CGFloat = 8
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant).isActive = true
        mainImageView.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
        mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: constant).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constant).isActive = true
    }
}

final class ShareOptionsController: UIViewController {
    
//    private struct Section {
//        let type: SectionType
//        let raws: [RawType]
//    }
//
//    private enum SectionType {
//        case installed
//        case newApps
//        case emptyTitle
//    }
    
    private enum RawType {
        case qrCode
        
        var cellId: String {
            switch self {
            case .qrCode:
                return String(describing: ImageCell.self)
            }
        }
    }
    
//    private var sections: [Section] = []
    private let raws: [RawType] = [.qrCode]
    private var apps: SchemeAppTuple = ([], [])
    private let cellId = String(describing: DetailCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
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
        
        /// if you set title in viewDidLoad(loadView too), it will not be set in language changing
        title = L10n.developerApps
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
    
    /// need for iOS 11(maybe others too. iOS 10 don't need) split controller, opened in landscape with large text accessibility
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
}

// MARK: - UIViewControllerRestoration
extension ShareOptionsController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        assert(String(describing: self) == identifierComponents.last, "unexpected restoration path: \(identifierComponents)")
        return ShareOptionsController(coder: coder)
    }
}

// MARK: - UITableViewDataSource
extension ShareOptionsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return raws.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let raw = raws[indexPath.row]
        
        switch raw {
        case .qrCode:
            return tableView.dequeueReusableCell(withIdentifier: raw.cellId, for: indexPath)
        }
    }
}

// MARK: - UITableViewDelegate
extension ShareOptionsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let raw = raws[indexPath.row]
        
        switch raw {
        case .qrCode:
            guard let cell = cell as? ImageCell else {
                assertionFailure()
                return
            }
            cell.mainImageView.image = UIImage()
        }
        
//        let raw = raws[indexPath.row]
//
//        switch raw {
//        case .feedback:
//            cell.accessoryType = .none
//            cell.setup(title: L10n.sendFeedback)
//        case .privacyPolicy:
//            cell.accessoryType = .disclosureIndicator
//            cell.setup(title: L10n.privacyPolicy)
//        case .rateApp:
//            cell.accessoryType = .none
//            cell.setup(title: L10n.rateUs)
//        case .appStorePage:
//            cell.accessoryType = .none
//            cell.setup(title: L10n.openInAppStore)
//        case .developerPage:
//            cell.accessoryType = .disclosureIndicator
//            cell.setup(title: L10n.moreAppsFromMe)
//        case .shareApp:
//            cell.accessoryType = .none
//            cell.setup(title: L10n.shareApp)
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? AboutHeader else {
            assertionFailure()
            return
        }
        
        header.label.text = L10n.settings
        header.imageView.image = Images.icSettings
        header.versionLabel.text = UIApplication.shared.version
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        VibrationManager.shared.lightVibrate()
        SoundManager.shared.playTapSound()
//        let raw = raws[indexPath.row]
//
//        switch raw {
//        case .feedback:
//            sendFeedback()
//        case .privacyPolicy:
//            let vc = PrivacyPolicyController()
//            navigationController?.pushViewController(vc, animated: true)
//        case .rateApp:
//            RateAppManager.googleApp.rateInAppOrRedirectToStore()
//        case .appStorePage:
//            RateAppManager.googleApp.openAppStorePage()
//        case .developerPage:
//            let vc = DeveloperAppsController()
//            navigationController?.pushViewController(vc, animated: true)
//        case .shareApp:
//            RateAppManager.googleApp.shareApp(in: self)
//        }
    }
}
