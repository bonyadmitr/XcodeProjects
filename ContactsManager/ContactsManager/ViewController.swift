//
//  ViewController.swift
//  ContactsManager
//
//  Created by Bondar Yaroslav on 9/21/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContactsManager.shared.requestContactsAccess { status in
            switch status {
            case .success:
                print("success")
//                ContactsManager.shared.create(name: "111")
//                ContactsManager.shared.create(name: "222")
                ContactsManager.shared.getContacts()
            case .denied:
                print("denied")
            }
        }
        
        
    }
}

import Contacts

/// https://developer.apple.com/documentation/contacts
/// Info.plist: NSContactsUsageDescription
final class ContactsManager {
    
    static let shared = ContactsManager()
    
    private let store = CNContactStore()
    
    func create(name: String) {
        // Creating a mutable object to add to the contact
        let contact = CNMutableContact()
        
        //contact.imageData = Data() // The profile picture as a NSData object
        
        contact.givenName = name
        contact.familyName = "Appleseed"
        
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: "john@example.com" as NSString)
        let workEmail = CNLabeledValue(label: CNLabelWork, value: "j.appleseed@icloud.com" as NSString)
        contact.emailAddresses = [homeEmail, workEmail]
        
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:"(408) 555-0126"))]
        
        let homeAddress = CNMutablePostalAddress()
        homeAddress.street = "1 Infinite Loop"
        homeAddress.city = "Cupertino"
        homeAddress.state = "CA"
        homeAddress.postalCode = "95014"
        let contactHomeAddress = CNLabeledValue(label: CNLabelHome, value: homeAddress as CNPostalAddress)
        contact.postalAddresses = [contactHomeAddress]
        
        var birthday = DateComponents()
        birthday.day = 1
        birthday.month = 4
        birthday.year = 1988  // You can omit the year value for a yearless birthday
        contact.birthday = birthday
        
        // Saving the newly created contact
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        try? store.execute(saveRequest)
    }
    
    /// To avoid having your app’s UI main thread block for this access, you can use either the asynchronous method requestAccess(for:completionHandler:) or dispatch your CNContactStore usage to a background thread
    func requestContactsAccess(handler: @escaping AccessStatusHandler) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            handler(.success)
        case .denied, .restricted:
            handler(.denied)
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                if granted {
                    handler(.success)
                } else {
                    handler(.denied)
                }
            }
        }
    }
    
    func getContacts() {
//        let contactFetchRequest = CNContactFetchRequest(keysToFetch: allowedContactKeys())
//        var contactsArray = [CNContact]()
//        try? store.enumerateContacts(with: contactFetchRequest) { contact, _ in
//            contactsArray.append(contact)   
//        }
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try store.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do {
                let containerResults = try store.unifiedContacts(matching: fetchPredicate, keysToFetch: allowedContactKeys())
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        print("results.count: ", results.count)
        
        
        
        
        
        
        
        
        
        guard let contact = results.first else {
            return
        }
        
        /// if you try to get contact property without fetch it
        /// it will crash with error "A property was not requested when contact was fetched"
        /// Example for "givenName"
        
        print("contact.givenName:", contact.givenName)
        
        if contact.isKeyAvailable(CNContactEmailAddressesKey) {
            print("contact.emailAddresses:", contact.emailAddresses.first?.value ?? "nil")
        } else {
            /// you should add all previus contact keysToFetch
            let refetchedContact = try? store.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [CNContactEmailAddressesKey as CNKeyDescriptor])
            print("refetchedContact.emailAddresses:", refetchedContact?.emailAddresses.first?.value ?? "nil")
            
            /// crash here
            //print("refetchedContact.givenName:", refetchedContact.givenName)
            
        }


        
////        let fetchPredicate2 = CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier())
//        let fetchPredicate2 = CNContact.predicateForContacts(matchingName: "Aaa")
//        do {
//            
//            let containerResults = try store.unifiedContacts(matching: fetchPredicate2, keysToFetch: allowedContactKeys())
//            print(containerResults.count)
//        } catch {
//            print("Error fetching results for container")
//        }
    }
    
    ///We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
    func allowedContactKeys() -> [CNKeyDescriptor]{
        return [
            CNContactPhoneNumbersKey,
//            CNContactEmailAddressesKey,
            CNContactNamePrefixKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            //CNContactOrganizationNameKey,
            //CNContactBirthdayKey,
            //CNContactImageDataKey,
            //CNContactThumbnailImageDataKey,
            //CNContactImageDataAvailableKey
        ] as [CNKeyDescriptor]
        //+ [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
    }
}

typealias AccessStatusHandler = (_ status: AccessStatus) -> Void

enum AccessStatus {
    case success
    case denied
}

