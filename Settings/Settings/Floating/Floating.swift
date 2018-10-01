//
//  Floating.swift
//  WindowFloating
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class Floating {
    
    enum FloatingMode {
        case shake
        case button
        case none
    }
    
    static var showOnShakeMotion = false
    static var isShownOnShake = false
    
    static var mode: FloatingMode = .button {
        didSet {
            switch mode {
            case .button:
                showOnShakeMotion = false
                FloatingManager.shared.enableFloatingView() 
            case .shake:
                showOnShakeMotion = true
                FloatingManager.shared.disableFloatingView()
            case .none:
                showOnShakeMotion = false
                FloatingManager.shared.disableFloatingView() 
            }
        }
    }
}

#if DEBUG
extension UIWindow {
    override open func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake, Floating.showOnShakeMotion, !Floating.isShownOnShake {
            Floating.isShownOnShake = true
            if let vc = FloatingManager.shared.presentingController {
                rootViewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
#endif

final class FloatingNavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        let leftButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(exit))
        rootViewController.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func exit() {
        Floating.isShownOnShake = false
        dismiss(animated: true, completion: nil)
    }
}

final class FloatingPresentingController: UIViewController {
    
    private enum Section: Int {
        case debug = 0
        
        static let count = 1
        
        enum DebugRaws: Int {
            case crashApp = 0
            
            static let count = 1
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        title = "Debug"
        //extendedLayoutIncludesOpaqueBars = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: .willEncodeRestorableState, object: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
    
    private var isGoingToCrash = false
    
    @objc private func appMovedToBackground() {
        if isGoingToCrash {
            UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            dismiss(animated: false) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    exit(0)
                }
            }
        }
    }
}

extension FloatingPresentingController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            assertionFailure()
            return 0
        }
        switch section {
        case .debug: return Section.DebugRaws.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
}

extension FloatingPresentingController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            assertionFailure()
            return
        }
        
        switch section {
        case .debug:
            guard let row = Section.DebugRaws(rawValue: indexPath.row) else {
                assertionFailure()
                return
            }
            
            switch row {
            case .crashApp:
//                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "Crash the app for UIStateRestoration"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(rawValue: indexPath.section) else {
            assertionFailure()
            return
        }
        
        switch section {
        case .debug:
            guard let row = Section.DebugRaws(rawValue: indexPath.row) else {
                assertionFailure()
                return
            }
            
            switch row {
            case .crashApp:
                isGoingToCrash = true
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else {
            assertionFailure()
            return nil
        }
        
        switch section {
        case .debug:
            return "debug"
        }
    }
}
