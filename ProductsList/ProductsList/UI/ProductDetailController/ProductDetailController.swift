import UIKit

final class ProductDetailController: UIViewController, ErrorPresenter {
    
    typealias Model = Product
    typealias Item = ProductItemDB
    typealias View = ProductDetailView
    
    private let service = Model.Service()
    private lazy var storage = Item.Storage()
    
    private lazy var vcView: View = {
        if let view = self.view as? View {
            return view
        } else {
            assertionFailure("setup view in IB")
            return View()
        }
    }()
    
    private var item: Item?
    
    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.item = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        self.item = nil
        //assertionFailure("init from code only")
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = item {
            setup(for: item)
        }
    }
    
    private func setup(for item: Item) {
        title = item.name
        vcView.setup(for: item)
        loadDetail(for: item)
    }
    
    private func loadDetail(for item: Item) {
        guard let id = item.originalId else {
            assertionFailure()
            showErrorAlert(with: "Something went wrong with server")
            return
        }
        
        service.detail(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detailedItem):
                    self?.handle(detailedItem: detailedItem)
                    
                case .failure(let error):
                    self?.showErrorAlert(for: error)
                }
            }
        }
    }
    
    private func handle(detailedItem: Product.DetailItem) {
        vcView.setupDetail(from: detailedItem)
        
        storage.updateSaved(item: item, with: detailedItem) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showErrorAlert(for: error)
                } else {
                    // can be shown alert
                    print("success. item updated")
                }
            }
        }
    }
    
}











// MARK: - NSUserActivity Support

extension ProductDetailController {

    // Encode and decode keys for saving the NSUserActivity to the restoration archive (non-scene based).
    static let restoreActivityKey = "RestoreActivity"
    static let activityTitleKey = "title"
//    static let activityNotesKey = "notes"
    static let activityIdentifierKey = "identifier"
//    static let activityEditStateKey = "editState"
    
    /** Create the user activity type.
        Note: The activityType string loaded below must be included in your Info.plist file under the `NSUserActivityTypes` array.
            More info: https://developer.apple.com/documentation/foundation/nsuseractivity
    */
    class var activityType: String {
        let activityType = ""
        
        // Load our activity type from our Info.plist.
        if let activityTypes = Bundle.main.infoDictionary?["NSUserActivityTypes"] {
            if let activityArray = activityTypes as? [String] {
                return activityArray[0]
            }
        }
        
        return activityType
    }

    func applyUserActivityEntries(_ activity: NSUserActivity) {
        guard let item = item else {
            assertionFailure()
            return
        }
        
        let itemTitle: [String: String] = [ProductDetailController.activityTitleKey: title!]
        activity.addUserInfoEntries(from: itemTitle)
//
//        let itemNotes: [String: String] = [ProductDetailController.activityNotesKey: detailNotes.text!]
//        activity.addUserInfoEntries(from: itemNotes)
//
//        // We remember the item's identifier for unsaved changes.
        let itemIdentifier: [String: Any] = [ProductDetailController.activityIdentifierKey: item.objectID.uriRepresentation()]
        activity.addUserInfoEntries(from: itemIdentifier)
//
//        // Remember the edit mode state to restore next time (we compare the orignal note with the unsaved note).
//        let originalItem = DataSource.shared().itemFromIdentifier(detailItem!.identifier)
//        let nowEditing = originalItem.title != detailName.text || originalItem.notes != detailNotes.text
//        let nowEditingSaveState: [String: Bool] = [DetailViewController.activityEditStateKey: nowEditing]
//        activity.addUserInfoEntries(from: nowEditingSaveState)
    }
    
    // Used to construct an NSUserActivity instance for state restoration.
    var detailUserActivity: NSUserActivity {
        let userActivity = NSUserActivity(activityType: ProductDetailController.activityType)
        userActivity.title = "Restore Item"
        applyUserActivityEntries(userActivity)
        
        /// to test handoff
        userActivity.becomeCurrent()
        self.userActivity = userActivity
        
        return userActivity
    }

    func restoreItemInterface(_ activityUserInfo: [AnyHashable: Any]) {
        let itemTitle = activityUserInfo[ProductDetailController.activityTitleKey] as? String
        title = itemTitle
        
        let context = CoreDataStack.shared.viewContext
//        CoreDataStack.shared.performBackgroundTask { context in
            if let itemID = activityUserInfo[ProductDetailController.activityIdentifierKey] as? URL,
                let id = CoreDataStack.shared.managedObjectID(for: itemID),
                let item = context.object(with: id) as? Item
            {
                self.item = item
                self.setup(for: item)
            }
            
//        }
        
        
        
        
        
        
        
//        let itemNotes = activityUserInfo[DetailViewController.activityNotesKey] as? String
//        let itemIdentifier = activityUserInfo[DetailViewController.activityIdentifierKey] as? String
//
//        detailItem = Item(title: itemTitle!, notes: itemNotes!, identifier: itemIdentifier)
//
//        if let editingState = activityUserInfo[DetailViewController.activityEditStateKey] as? Bool {
//            restoredEditState = editingState
//        }
    }
    
//    func stopUserActivity() {
//        userActivity?.invalidate()
//    }
}

// MARK: - UIUserActivityRestoring

extension ProductDetailController {
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)
        applyUserActivityEntries(activity)
    }

    override func restoreUserActivityState(_ activity: NSUserActivity) {
         super.restoreUserActivityState(activity)
        
        // Check if the activity is of our type.
        if activity.activityType == ProductDetailController.activityType {
            // Get the user activity data.
            if let activityUserInfo = activity.userInfo {
                restoreItemInterface(activityUserInfo)
            }
        }
    }

}

// MARK: - State Restoration (UIStateRestoring)

extension ProductDetailController {
    
/// - Tag: encodeRestorableState
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)

        let encodedActivity = NSUserActivityEncoder(detailUserActivity)
        coder.encode(encodedActivity, forKey: ProductDetailController.restoreActivityKey)
    }
   
/// - Tag: decodeRestorableState
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        if coder.containsValue(forKey: ProductDetailController.restoreActivityKey) {
            if let decodedActivity = coder.decodeObject(forKey: ProductDetailController.restoreActivityKey) as? NSUserActivityEncoder {
                if let activityUserInfo = decodedActivity.userActivity.userInfo {
                    restoreItemInterface(activityUserInfo)
                }
            }
        }
    }
    
}















import Foundation

// MARK: - NSUserActivity Encoding-Decoding Support

/** NSUserActivity does not conform to NSCoding protocol, so we have a convenience wrapper class
    to be used to store this user activity as an archive for non-scene state restoration.
*/
class NSUserActivityEncoder: NSObject, NSCoding {
    private let activityTypeKey = "activityType"
    private let activityTitleKey = "activityTitle"
    private let activityUserInfoKey = "activityUserInfo"
    
    private (set) var userActivity: NSUserActivity

    init(_ userActivity: NSUserActivity) {
        self.userActivity = userActivity
    }

    required init?(coder: NSCoder) {
        if let activityType = coder.decodeObject(forKey: activityTypeKey) as? String {
            userActivity = NSUserActivity(activityType: activityType)
            if let title = coder.decodeObject(forKey: activityTitleKey) as? String {
                userActivity.title = title
            }
            if let userInfo = coder.decodeObject(forKey: activityUserInfoKey) as? [AnyHashable: Any] {
                userActivity.userInfo = userInfo
            }
        } else {
            return nil
        }
    }

    func encode(with coder: NSCoder) {
        coder.encode(userActivity.activityType, forKey: activityTypeKey)
        coder.encode(userActivity.title, forKey: activityTitleKey)
        coder.encode(userActivity.userInfo, forKey: activityUserInfoKey)
    }
}
