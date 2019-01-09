//
//  ViewController.swift
//  ActivityViewController
//
//  Created by Bondar Yaroslav on 1/9/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showActivityVC()
        }
    }
    
    @IBAction private func showActivity(_ sender: UIButton) {
        showActivityVC()
    }

    private func showActivityVC() {
        /// abstract class
        //let activity = UIActivity()
        
        //let objectsToShare = ["Some text"]
        let objectsToShare = [UIImage(color: .red, size: CGSize(width: 100, height: 100))!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        let activityVC = ActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [
            .airDrop, .openInIBooks, .saveToCameraRoll, .assignToContact,
            .copyToPasteboard,
            /// does not work in iOS 9.3, working in iOS 10.3 and 11
            /// https://stackoverflow.com/a/39710905/5893286
            UIActivity.ActivityType(rawValue: "by.come.life.Lifebox.LifeboxShared")
//            UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
//            UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
//            UIActivity.ActivityType(rawValue: "com.google.Drive.ShareExtension")
        ]
        
        present(activityVC, animated: true, completion: nil)
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

/// not working
/// https://stackoverflow.com/questions/31792506/how-to-exclude-notes-and-reminders-apps-from-the-uiactivityviewcontroller
/// https://stackoverflow.com/questions/39599820/uiactivities-in-swift-3
class ActivityViewController: UIActivityViewController {
    override init(activityItems: [Any], applicationActivities: [UIActivity]?) {
        super.init(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func _shouldExcludeActivityType(activity: UIActivity) -> Bool {
        let activityTypesToExclude = [
            .airDrop, .openInIBooks, .saveToCameraRoll, .assignToContact,
            .copyToPasteboard,
            UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
            UIActivity.ActivityType(rawValue: "com.google.Drive.ShareExtension")
        ]

        if let actType = activity.activityType {
            if activityTypesToExclude.contains(actType) {
                return true
            }
            else if super.excludedActivityTypes != nil {
                return super.excludedActivityTypes!.contains(actType)
            }
        }
        return false
    }
    
    internal func _shouldExcludeActivityType(_ activity: UIActivity) -> Bool {
        
        let activityTypesToExclude: [UIActivity.ActivityType] = [
            .remindersEditorExtension,
            .openInIBooks,
            .print,
            .assignToContact,
            .postToWeibo,
            .googleDriveShareExtension,
            .streamShareService
        ]
        
        if let actType = activity.activityType {
            if activityTypesToExclude.contains(actType) {
                return true
            } else if let superExcludes = super.excludedActivityTypes {
                return superExcludes.contains(actType)
            }
        }
        return false
    }
}
extension UIActivity.ActivityType {
    static let remindersEditorExtension = UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension")
    static let googleDriveShareExtension = UIActivity.ActivityType(rawValue: "com.google.Drive.ShareExtension")
    static let streamShareService = UIActivity.ActivityType(rawValue: "com.apple.mobileslideshow.StreamShareService")
}


//class FavoriteActivity: UIActivity {
//    override func activityType() -> String? {
//        return "TestActionss.Favorite"
//    }
//
//    override func activityTitle() -> String? {
//        return "Add to Favorites"
//    }
//
//    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
//        NSLog("%@", __FUNCTION__)
//        return true
//    }
//
//    override func prepareWithActivityItems(activityItems: [AnyObject]) {
//        NSLog("%@", __FUNCTION__)
//    }
//
//    override func activityViewController() -> UIViewController? {
//        NSLog("%@", __FUNCTION__)
//        return nil
//    }
//
//    override func performActivity() {
//        // Todo: handle action:
//        NSLog("%@", __FUNCTION__)
//
//        self.activityDidFinish(true)
//    }
//
//    override func activityImage() -> UIImage? {
//        return UIImage(named: "favorites_action")
//    }
//}

//class ActivityViewCustomActivity: UIActivity {
//
//    // MARK: Properties
//
//    var customActivityType: UIActivityType
//    var activityName: String
//    var activityImageName: String
//    var customActionWhenTapped: () -> Void
//
//
//    // MARK: Initializer
//
//    init(title: String, imageName: String, performAction: @escaping () -> Void) {
//        self.activityName = title
//        self.activityImageName = imageName
//        self.customActivityType = UIActivityType(rawValue: "Action \(title)")
//        self.customActionWhenTapped = performAction
//        super.init()
//    }
//
//
//
//    // MARK: Overrides
//
//    override var activityType: UIActivityType? {
//        return customActivityType
//    }
//
//
//
//    override var activityTitle: String? {
//        return activityName
//    }
//
//
//
//    override class var activityCategory: UIActivityCategory {
//        return .share
//    }
//
//
//
//    override var activityImage: UIImage? {
//        return UIImage(named: activityImageName)
//    }
//
//
//
//    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
//        return true
//    }
//
//
//
//    override func prepare(withActivityItems activityItems: [Any]) {
//        // Nothing to prepare
//    }
//
//
//
//    override func perform() {
//        customActionWhenTapped()
//    }
//}


//class CustomActivity: UIActivity {
//
//    override class var activityCategory: UIActivityCategory {
//        return .action
//    }
//
//    override var activityType: UIActivityType? {
//        guard let bundleId = Bundle.main.bundleIdentifier else {return nil}
//        return UIActivityType(rawValue: bundleId + "\(self.classForCoder)")
//    }
//
//    override var activityTitle: String? {
//        return <# Title #>
//    }
//
//    override var activityImage: UIImage? {
//        return <# UIImage #>
//    }
//
//    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
//        return true
//    }
//
//    override func prepare(withActivityItems activityItems: [Any]) {
//        //
//    }
//
//    override func perform() {
//        activityDidFinish(true)
//    }
//}
