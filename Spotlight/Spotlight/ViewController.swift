//
//  ViewController.swift
//  Spotlight
//
//  Created by Bondar Yaroslav on 9/16/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        
        SpotlightManager.shared.start()
    }

}

import CoreSpotlight

/// inspire https://medium.com/better-programming/index-your-app-content-with-core-spotlight-def31cbb7736
final class SpotlightManager {
    
    static let shared = SpotlightManager()
    
    func start() {
        // TODO: use CSLocalizedString
        
        /// Try to fill as many attributes as you can — rich attributes sets will be translated better to search results and better user experience. Also, the search algorithm Apple uses prioritize richer results.
        let attributed = CSSearchableItemAttributeSet(itemContentType: "Text")
        attributed.title = "Spotlight contact"
        attributed.phoneNumbers = ["0544-xxxxxxx"]
        attributed.emailAddresses = ["avixxx@gmail.com"]
        attributed.contentDescription = "iOS Expert"
        
        /// Item identifier has two roles — one is to give the item a unique ID, so you can delete or modify it in the future, and the second one is when the user taps the item and opens your app, you can load the relevant screen based on the identifier passed
        /// Domain identifier is an optional parameter and it is used to group search results for the user. It can also help you delete items from a specific domain very easily.
        /// Another attribute a searchable item has is an expiration date. By default, the expiration date of an item is one month, but you can override this property anytime
        let contactItem = CSSearchableItem(uniqueIdentifier: "123456",
                                           domainIdentifier: "Contacts",
                                           attributeSet: attributed)
        
        CSSearchableIndex.default().indexSearchableItems([contactItem]) { (error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            } else {
                print("Completed successfully")
            }
        }

    }
    
    func addUserActivity() {
        let userActivity = NSUserActivity(activityType: "com.searchtutorial.www")
        userActivity.title = "Search Tutorial"
        userActivity.isEligibleForSearch = true
        userActivity.isEligibleForHandoff = true
        if #available(iOS 12.0, *) {
            userActivity.isEligibleForPrediction = true
        }
        
        /// This means that this search result can appear for other users as well, even if they don’t have your app installed (!). So, never set this property to true, unless you are sure this is not private user content.
        userActivity.isEligibleForPublicIndexing = true
        
        userActivity.keywords = ["search", "tutorial", "spotlight"]
        userActivity.userInfo = ["id" : "tutorial123"]
        
        let attributed = CSSearchableItemAttributeSet(itemContentType: "Article")
        attributed.title = "Search Tutorial"
        attributed.emailAddresses = ["avixxx@gmail.com"]
        attributed.contentDescription = "How to search your items with Core Spotlight"
        
        userActivity.contentAttributeSet = attributed
        
        userActivity.becomeCurrent()
    }

    
    func delete() {
        // delete all items
        CSSearchableIndex.default().deleteAllSearchableItems { (error) in
            
        }
        
        // delete certain items by identifiers
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["aviID"]) { (error) in
            
        }

        // delete all items from specific domains
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: ["contacts"]) { (error) in
            
        }
    }
}
