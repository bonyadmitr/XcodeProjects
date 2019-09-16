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

final class SpotlightManager {
    
    static let shared = SpotlightManager()
    
    func start() {
        let attributed = CSSearchableItemAttributeSet(itemContentType: "Text")
        attributed.title = "Spotlight contact"
        attributed.phoneNumbers = ["0544-xxxxxxx"]
        attributed.emailAddresses = ["avixxx@gmail.com"]
        attributed.contentDescription = "iOS Expert"
        
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
}
