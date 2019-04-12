//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Bondar Yaroslav on 09/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

/// Remember: Torn on AppGroups for main and extension targets
/// 'Failed to inherit CoreMedia permissions from xxxx' is noraml bug of xcode

/// Example of More button for iOS 9
///@IBAction func showMore(sender: UIButton) {
///    if widgetExpanded {
///        moreDetailsContainerHeightConstraint.constant = 0
///        showMoreButton.transform = CGAffineTransformMakeRotation(0)
///        widgetExpanded = false
///    } else {
///        moreDetailsContainerHeightConstraint.constant = 220
///        showMoreButton.transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI/180.0))
///        widgetExpanded = true
///    }
///}

/// loadView and viewDidLoad calls after some seconds of hidden widget
class TodayViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var shownLabel: UILabel!
    @IBOutlet weak var someLabel: UILabel!
    
    var timer: Timer!
    var timerCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOSApplicationExtension 10.0, *) {
//            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
////            widgetActiveDisplayModeDidChange(.compact, withMaximumSize: CGSize(width: 500, height: 100))
//        }
//        preferredContentSize.height = 100
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changedSomeTextField), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }

    
    
    @objc func changedSomeTextField(_ notification: Notification) {
        someLabel.text = SharedUserDefaults.shared.someText
    }
    
    @IBAction func openMainAppButton(_ sender: UIButton) {
        extensionContext?.open("main-app://")
    }
    
    func updateWidget() {
        SharedUserDefaults.shared.shownCounter += 1
        shownLabel.text = String(SharedUserDefaults.shared.shownCounter)

//        let q = SharedUserDefaults.shared.shownCounter % 2 == 1
//        UIView.animate(withDuration: 0.3) {
//            self.someLabel.isHidden = q
//            /// https://stackoverflow.com/a/46412621/5893286
//            self.view.layoutIfNeeded()
//        }
        
        let q = SystemUtils.isDeviceLocked()
//        let q = SharedUserDefaults.shared.shownCounter % 2 == 1
        print("q", q)
        UIView.animate(withDuration: 0.3) {
            self.someLabel.isHidden = q
            /// https://stackoverflow.com/a/46412621/5893286
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func updateCounter() {
        timerCounter += 1
        timerLabel.text = String(timerCounter)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit TodayViewController")
    }
}

extension TodayViewController: NCWidgetProviding {
    
    /// "This method will not be called on widgets linked against iOS versions 10.0 and later."
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return .zero
    }
    
    /// Perform any setup necessary in order to update the view.
    /// If an error is encountered, use NCUpdateResult.Failed
    /// If there's no update required, use NCUpdateResult.NoData
    /// If there's an update, use NCUpdateResult.NewData
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        updateWidget()
        completionHandler(.newData)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            /// maxSize for iPhone 5: width 304.0, height 110.0
            preferredContentSize = maxSize //CGSize(width: maxSize.width, height: 100)
        } else { /// expanded
            preferredContentSize = CGSize(width: maxSize.width, height: 300)
        }
    }

}
