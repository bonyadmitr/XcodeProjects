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
        case shareApp
    }
    
    private let cellId = String(describing: DetailCell.self)
    private let raws: [RawType] = [.feedback, .privacyPolicy, .rateApp, .appStorePage, .developerPage, .shareApp]
    
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
        super.traitCollectionDidChange(previousTraitCollection)
        
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
        case .shareApp:
            cell.accessoryType = .disclosureIndicator
            cell.setup(title: L10n.shareApp)
        }
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
        case .shareApp:
            let vc = ShareOptionsController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


import UIKit

/// QRCode generator
/// https://github.com/aschuch/QRCode
public final class QRCode {
    
    /**
     The level of error correction.
     
     - Low:      7%
     - Medium:   15%
     - Quartile: 25%
     - High:     30%
     */
    public enum ErrorCorrection: String {
        case low = "L"
        case medium = "M"
        case quartile = "Q"
        case high = "H"
    }
    
    /// Data contained in the generated QRCode
    public var data: Data?
    
    /// Foreground color of the output
    /// Defaults to black
    public var mainColor = CIColor(red: 0, green: 0, blue: 0)
    
    /// Background color of the output
    /// Defaults to white
    public var backgroundColor = CIColor(red: 1, green: 1, blue: 1)
    
    /// Size of the output
    public var size = CGSize(width: 200, height: 200)
    
    /// The error correction. The default value is `.Low`.
    public var errorCorrection = ErrorCorrection.low
    
    // MARK: Init
    
    init() {}
    
    public init(mainColor: UIColor, backgroundColor: UIColor) {
        self.mainColor = mainColor.ciColor
        self.backgroundColor = backgroundColor.ciColor
    }
    
    func setup(_ data: Data?) {
        self.data = data
    }
    
    func setup(_ url: URL) {
        data = url.absoluteString.data(using: .isoLatin1)
    }
    
    func setup(_ string: String) {
        data = string.data(using: .isoLatin1)
    }
    
    // MARK: Generate QRCode
    
    /// The QRCode's UIImage representation
    public func image() -> UIImage? {
        guard let ciImage = ciImage() else {
            assertionFailure()
            return nil
        }
        
        // Size
        let ciImageSize = ciImage.extent.size
        let widthRatio = size.width / ciImageSize.width
        let heightRatio = size.height / ciImageSize.height
        let scale = Scale(dx: widthRatio, dy: heightRatio)
        return ciImage.nonInterpolatedImage(with: scale)
    }
    
    /// The QRCode's CIImage representation
    public func ciImage() -> CIImage? {
        
        guard let data = data else {
            assertionFailure()
            return nil
        }
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            assertionFailure()
            return nil
        }
        
        qrFilter.setDefaults()
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue(errorCorrection.rawValue, forKey: "inputCorrectionLevel")
        
        // Color code and background
        guard let colorFilter = CIFilter(name: "CIFalseColor") else {
            assertionFailure()
            return nil
        }
        
        colorFilter.setDefaults()
        colorFilter.setValue(qrFilter.outputImage, forKey: "inputImage")
        colorFilter.setValue(mainColor, forKey: "inputColor0")
        colorFilter.setValue(backgroundColor, forKey: "inputColor1")
        
        return colorFilter.outputImage
    }
    
    func generateInBackground(completion: @escaping ResultHandler<UIImage>) {
        DispatchQueue.global().async { [weak self] in
            if let image = self?.image() {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                DispatchQueue.main.async {
                    // TODO: error
                    let error = NSError(domain: "", code: 0, userInfo: nil)
                    completion(.failure(error))
                }
            }
        }
    }
    
//    func barcodeImage() -> UIImage? {
//
//        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
//            assertionFailure()
//            return nil
//        }
//
//        filter.setValue(data, forKey: "inputMessage")
//        let transform = CGAffineTransform(scaleX: 3, y: 3)
//
//        if let output = filter.outputImage?.transformed(by: transform) {
//            return UIImage(ciImage: output)
//        }
//
//        return nil
//    }
}
