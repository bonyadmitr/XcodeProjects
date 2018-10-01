//
//  ViewController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        willSet {
//            newValue.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 50, right: 0)
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
        title = "language".localized
        
        /// if need separate localization
        //tabBarItem = UITabBarItem(title: "language".localized, image: nil, selectedImage: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}

// MARK: - UIStateRestoration
extension ViewController {
    
    /// Constants for state restoration.
    private static let restoreTableViewOffet = "restoreTableViewOffet"
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        coder.encode(tableView.contentOffset, forKey: ViewController.restoreTableViewOffet)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        let contentOffset = coder.decodeCGPoint(forKey: ViewController.restoreTableViewOffet)
        tableView.setContentOffset(contentOffset, animated: false)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
//        cell.textLabel?.textColor = AppearanceConfigurator.shared.currentTheme.textColor
    }
}


final class SampleDesigner: NSObject {
    @IBOutlet private weak var sampleLabel: UILabel! {
        willSet {
            newValue.text = "language".localized
        }
    }
}
