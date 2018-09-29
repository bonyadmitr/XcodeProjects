//
//  ViewController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
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
//        automaticallyAdjustsScrollViewInsets = false
    }
    
//    override func applicationFinishedRestoringState() {
//        super.applicationFinishedRestoringState()
//        automaticallyAdjustsScrollViewInsets = true
//    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }
}


final class SampleDesigner: NSObject {
    @IBOutlet private weak var sampleLabel: UILabel! {
        willSet {
            newValue.text = "language".localized
        }
    }
}
