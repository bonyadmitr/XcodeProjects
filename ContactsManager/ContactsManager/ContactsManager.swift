//
//  ContactsManager.swift
//  ContactsManager
//
//  Created by Bondar Yaroslav on 9/21/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Contacts


// TODO: Merge duplicate https://stackoverflow.com/a/46023501
// TODO: progress callback https://developer.apple.com/documentation/foundation/progress
// TODO: background queue
// TODO: manual Merge duplicate by selecting controller
// TODO: Merge all duplicate
// TODO: view all contacts controller

typealias DuplicatesByName = [String: [CNContact]]

/// if you try to get contact property without fetch it
/// it will crash with error "A property was not requested when contact was fetched"
/// Example for "givenName"
///
//print("contact.givenName:", contact.givenName)
//
//if contact.isKeyAvailable(CNContactEmailAddressesKey) {
//    print("contact.emailAddresses:", contact.emailAddresses.first?.value ?? "nil")
//} else {
//    /// you should add all previus contact keysToFetch
//    let refetchedContact = try? contactStore.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [CNContactEmailAddressesKey as CNKeyDescriptor])
//    print("refetchedContact.emailAddresses:", refetchedContact?.emailAddresses.first?.value ?? "nil")
//    
//    /// crash here
//    //print("refetchedContact.givenName:", refetchedContact.givenName)
//    
//}

/// https://developer.apple.com/documentation/contacts
/// https://github.com/satishbabariya/SwiftyContacts/blob/master/Sources/Core/SwiftyContacts.swift
/// Info.plist: NSContactsUsageDescription
final class ContactsManager: NSObject {
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contactStoreDidChange), name: .CNContactStoreDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func contactStoreDidChange(_ notification: Notification) {
//        print("---", notification)
        print("---", notification.userInfo!)
    }
    
    static let shared = ContactsManager()
    
    let contactStore = CNContactStore()
    
    /// let q = CNLabeledValue<NSString>.localizedString(forLabel: contactHomeAddress.label!)
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
        try? contactStore.execute(saveRequest)
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
    
    ///We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
    var allowedContactKeys: [CNKeyDescriptor] {
        return [
            CNContactPhoneNumbersKey,
            //CNContactEmailAddressesKey,
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
    
    static var allContactKeys: CNKeyDescriptor {
        return CNContactVCardSerialization.descriptorForRequiredKeys()
    }
    
    /// https://stackoverflow.com/q/32669612
    func fetchAllContacts(keysToFetch: [CNKeyDescriptor] = [ContactsManager.allContactKeys], completion: @escaping ContactsResult) {
        var allContainers = [CNContainer]()
        
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            completion(.failure(error))
        }
        
        var contacts = [CNContact]()
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                contacts.append(contentsOf: containerResults)
            } catch {
                completion(.failure(error))
            }
        }
        
        completion(.success(contacts))
        
//        CNContact.descriptorForAllComparatorKeys()
    }
    
    public func fetchContacts(sortOrder: CNContactSortOrder, completion: @escaping ContactsResult) {
        
        // TODO: check
//        CNContactsUserDefaults.shared().sortOrder
        
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: [ContactsManager.allContactKeys])
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = sortOrder
        
        do {
            var contacts = [CNContact]()
            try contactStore.enumerateContacts(with: fetchRequest) { contact, _ in
                contacts.append(contact)   
            }
            completion(.success(contacts))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func fetchContacts(searchString: String, completion: @escaping ContactsResult) {
        let predicate = CNContact.predicateForContacts(matchingName: searchString)
        do {
            let contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: [ContactsManager.allContactKeys])
            completion(.success(contacts))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func fetchContacts(contactIdentifiers: [String], keysToFetch: [CNKeyDescriptor] = [ContactsManager.allContactKeys], completion: @escaping ContactsResult) {
        let predicate: NSPredicate = CNContact.predicateForContacts(withIdentifiers: contactIdentifiers)
        do {
            let contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            completion(.success(contacts))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func createContact(_ contact: CNMutableContact, containerIdentifier: String? = nil, completion: @escaping VoidResult) {
        let request = CNSaveRequest()
        request.add(contact, toContainerWithIdentifier: containerIdentifier)
        do {
            try contactStore.execute(request)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func updateContact(_ contact: CNMutableContact, completion: @escaping VoidResult) {
        let request = CNSaveRequest()
        request.update(contact)
        do {
            try contactStore.execute(request)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func deleteContact(_ contact: CNMutableContact, completion: @escaping VoidResult) {
        let request = CNSaveRequest()
        request.delete(contact)
        do {
            try contactStore.execute(request)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func convertToVCard(contacts: [CNContact], completion: @escaping HandlerResult<Data>) {
        do {
            let vcardFromContacts = try CNContactVCardSerialization.data(with: contacts)
            completion(.success(vcardFromContacts))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func convertToContacts(vCardData: Data, completion: @escaping ContactsResult) {
        do {
            let contacts = try CNContactVCardSerialization.contacts(with: vCardData)
            completion(.success(contacts))
        } catch {
            completion(.failure(error))
        }
    }

    
    
    // MARK: - without callback
    
    
    
    /// https://stackoverflow.com/q/32669612
    func fetchAllContacts(keysToFetch: [CNKeyDescriptor] = [ContactsManager.allContactKeys]) throws -> [CNContact] {
        var allContainers = [CNContainer]()
        allContainers = try contactStore.containers(matching: nil)
        
        var contacts = [CNContact]()
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
            contacts.append(contentsOf: containerResults)
        }
        return contacts
    }
    
    public func fetchContacts(sortOrder: CNContactSortOrder) throws -> [CNContact] {
        
        // TODO: check
        //        CNContactsUserDefaults.shared().sortOrder
        
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: [ContactsManager.allContactKeys])
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = sortOrder
        
        var contacts = [CNContact]()
        try contactStore.enumerateContacts(with: fetchRequest) { contact, _ in
            contacts.append(contact)   
        }
        return contacts
    }
    
    public func fetchContacts(searchString: String) throws -> [CNContact] {
        let predicate = CNContact.predicateForContacts(matchingName: searchString)
        return try contactStore.unifiedContacts(matching: predicate, keysToFetch: [ContactsManager.allContactKeys])
    }
    
    public func fetchContacts(contactIdentifiers: [String], keysToFetch: [CNKeyDescriptor] = [ContactsManager.allContactKeys]) throws -> [CNContact] {
        let predicate = CNContact.predicateForContacts(withIdentifiers: contactIdentifiers)
        return try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
    }
    
    public func fetchContacts(contactIdentifier: String, keysToFetch: [CNKeyDescriptor]) throws -> CNContact {
        return try contactStore.unifiedContact(withIdentifier: contactIdentifier, keysToFetch: keysToFetch)
    }
    
    public func createContact(_ contact: CNMutableContact, containerIdentifier: String? = nil) throws {
        let request = CNSaveRequest()
        request.add(contact, toContainerWithIdentifier: containerIdentifier)
        try contactStore.execute(request)
    }
    
    public func updateContact(_ contact: CNMutableContact) throws {
        let request = CNSaveRequest()
        request.update(contact)
        try contactStore.execute(request)
    }
    
    public func deleteContact(_ contact: CNMutableContact) throws {
        let request = CNSaveRequest()
        request.delete(contact)
        try contactStore.execute(request)
    }
    
    public func convertToVCard(contacts: [CNContact]) throws -> Data {
        return try CNContactVCardSerialization.data(with: contacts)
    }
    
    public func convertToContacts(vCardData: Data) throws -> [CNContact] {
        return try CNContactVCardSerialization.contacts(with: vCardData)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func findDuplicateContacts() throws -> DuplicatesByName {
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        /// maybe need CNContactIdentifierKey for older iOSs
        //let keys = [CNContactIdentifierKey as CNKeyDescriptor, CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        
        var duplicatesByName = DuplicatesByName()
        
        /// 1
        let request = CNContactFetchRequest(keysToFetch: keys)
        try contactStore.enumerateContacts(with: request) { contact, stop in
            guard let name = CNContactFormatter.string(from: contact, style: .fullName) else {
                return
            }
            duplicatesByName[name, default: []].append(contact)
        }
        
        /// 2
//        let contacts = try fetchAllContacts(keysToFetch: keys)
//        contacts.forEach { contact in
//            guard let name = CNContactFormatter.string(from: contact, style: .fullName) else {
//                return
//            }
//            duplicatesByName[name, default: []].append(contact)
//        }
        
        //duplicatesByName = duplicatesByName.filter { $1.count > 1 }
        
        return duplicatesByName.filter { $1.count > 1 }
    }
}

extension CNPhoneNumber {
    // TODO: check with stringValue
    var digits: String? {
        return value(forKey: "digits") as? String
    }
}

typealias AccessStatusHandler = (_ status: AccessStatus) -> Void

enum AccessStatus {
    case success
    case denied
}

typealias VoidResult = (Result<Void>) -> Void
//typealias BoolResult = (Result<Bool>) -> Void
typealias HandlerResult<T> = (Result<T>) -> Void
//typealias ArrayHandlerResult<T> = (Result<[T]>) -> Void
typealias ContactsResult = (Result<[CNContact]>) -> Void

enum Result<T> {
    case success(T)
    case failure(Error)
}

