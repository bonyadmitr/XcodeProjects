//
//  ShareOptionsController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 12/3/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

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
        case emailShare
        case systemShare
        
//        var cellId: String {
//
//            switch self {
//            case .qrCode:
//                return String(describing: ImageCell.self)
//            }
//        }
        
//        tableView.register(ImageCell.self, forCellReuseIdentifier: RawType.qrCode.cellId)
    }
    
//    private var sections: [Section] = []
    private let raws: [RawType] = [.emailShare, .systemShare]
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
        
        let insetsView = InsetImageView()
        insetsView.frame.size.height = UIScreen.main.bounds.width
        
        let inset: CGFloat = 50
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        insetsView.insets = insets
        tableView.tableHeaderView = insetsView
        
        let qr = QRCode()
        qr.setup("qwerty")
        qr.size = CGSize(width: UIScreen.main.bounds.width - inset * 2, height: UIScreen.main.bounds.width - inset * 2)
        let image = qr.image()!
        insetsView.imageView.image = image
    }
    
    /// need for iOS 11(maybe others too. iOS 10 don't need) split controller, opened in landscape with large text accessibility
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    private func shareViaEmail() {
        EmailSender.shared.send(message: "",
                                subject: NonL10n.emailTitle,
                                to: [EmailSender.devEmail],
                                attachments: [],
                                presentIn: self)
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
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ShareOptionsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? DetailCell else {
            assertionFailure()
            return
        }
        
        let raw = raws[indexPath.row]
        
        switch raw {
        case .emailShare:
            cell.accessoryType = .none
            cell.setup(title: L10n.shareAppEmail)
        case .systemShare:
            cell.accessoryType = .none
            cell.setup(title: L10n.shareAppSystem)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        VibrationManager.shared.lightVibrate()
        SoundManager.shared.playTapSound()
        
        let raw = raws[indexPath.row]
        
        switch raw {
        case .emailShare:
            shareViaEmail()
        case .systemShare:
            RateAppManager.googleApp.shareApp(in: self)
        }
    }
}
