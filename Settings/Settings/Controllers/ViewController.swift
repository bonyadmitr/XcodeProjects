//
//  ViewController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// Larger Dynamic Type from iOS 11 working for all types, not only .body
///
/// To see font sizes for Dynamic Types
/// https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/
///
/// Since iOS 10 you no longer need to observe the content size category did change notification
/// For iOS 10 use LABEL.adjustsFontForContentSizeCategory = true


// TODO: there is a bug after restoration state ofr lagerst font size
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
        
//        edgesForExtendedLayout = []
//        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
//        } else {
//            automaticallyAdjustsScrollViewInsets = false
//        }
        
        /// we have realod in AppDelegate
//        NotificationCenter.default.addObserver(self, selector: #selector(textSizeDidChange), name: .UIContentSizeCategoryDidChange, object: nil)
    }
    
    /// we have realod in AppDelegate
//    @objc private func textSizeDidChange(_ notification: Notification) {
//        /// don't need for iOS 10 and iOS 9
//        if #available(iOS 10.0, *) {
//            if traitCollection.preferredContentSizeCategory == .accessibilityExtraLarge ||
//                traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraLarge || 
//                traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraExtraLarge
//            {
//                UIView.performWithoutAnimation {
//                    self.tableView.beginUpdates()
//                    self.tableView.endUpdates()
//                }
//            }
//        }
//    }
    
    /// called on launch with previousTraitCollection == nil
    /// don't need for iOS 10 and iOS 9
    /// we have realod in AppDelegate
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        if #available(iOS 10.0, *) {
//            if let previousTraitCollection = previousTraitCollection,
//                previousTraitCollection.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory,
//                traitCollection.preferredContentSizeCategory == .accessibilityExtraLarge ||
//                    traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraLarge || 
//                    traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraExtraLarge
//            {
//                UIView.performWithoutAnimation {
//                    self.tableView.beginUpdates()
//                    self.tableView.endUpdates()
//                }
//            }
//        }
//    }
}

// MARK: - UIStateRestoration
extension ViewController {
    
    /// Constants for state restoration.
    private static let restoreTableViewOffet = "restoreTableViewOffet"
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        guard isViewLoaded else {
            return
        }
        
        coder.encode(tableView.contentOffset, forKey: type(of: self).restoreTableViewOffet)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        assert(isViewLoaded, "We assume the controller is never restored without loading its view first.")
        
        let contentOffset = coder.decodeCGPoint(forKey: type(of: self).restoreTableViewOffet)
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
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        /// need for iOS 10, don't need for iOS 11
        cell.textLabel?.numberOfLines = 0
        
//        if #available(iOS 10.0, *) {
//            cell.textLabel?.adjustsFontForContentSizeCategory = true
//        }
        
        cell.textLabel?.text = "Row ________ _ _ _ _ _ \(indexPath.row + 1)"
    }
}


//final class SampleDesigner: NSObject {
//    @IBOutlet private weak var sampleLabel: UILabel! {
//        willSet {
//            newValue.text = "language".localized
//        }
//    }
//}
