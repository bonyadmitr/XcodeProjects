//
//  FloatingPresentingController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 10/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class FloatingPresentingController: UIViewController {
    
    struct Section {
        let type: SectionType
        let raws: [RawType]
    }
    
    enum SectionType {
        case debug
    }
    
    enum RawType {
        case crashApp
        case moveToBackgroundAndCrash
        case sendLogs
    }
    
    private let sections = [Section(type: .debug,
                                    raws: [.crashApp, .moveToBackgroundAndCrash, .sendLogs])]
    
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
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
    
    private func sendLogs() {
        if FileManager.default.fileExists(atPath: Logger.shared.fileUrl.path),
            let logData = try? Data(contentsOf: Logger.shared.fileUrl)
        {
            let attachment = MailAttachment(data: logData, mimeType: "text/plain", fileName: "logs.txt")
            
            EmailSender.shared.send(message: "",
                                    subject: "Settings Debug",
                                    to: [EmailSender.devEmail],
                                    attachments: [attachment],
                                    presentIn: self)
        }
    }
}

extension FloatingPresentingController: UITableViewDataSource {
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

extension FloatingPresentingController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let raw = sections[indexPath.section].raws[indexPath.row]
        
        switch raw {
        case .crashApp:
            cell.textLabel?.text = "Crash the app"
        case .moveToBackgroundAndCrash:
            cell.textLabel?.text = "Background & crash in 1 sec"
        case .sendLogs:
            cell.textLabel?.text = "Send logs via email"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let raw = sections[indexPath.section].raws[indexPath.row]
        
        switch raw {
        case .crashApp:
            exit(0)
        case .moveToBackgroundAndCrash:
            isGoingToCrash = true
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        case .sendLogs:
            sendLogs()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        
        switch section.type {
        case .debug:
            return "Debug"
        }
    }
}
