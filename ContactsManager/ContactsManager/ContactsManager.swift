//
//  ContactsManager.swift
//  ContactsManager
//
//  Created by Bondar Yaroslav on 9/21/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Contacts

private let unknownError = NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo: nil)

// TODO: research classes
//CNPostalAddressFormatter
//CNContactFormatter
//CNContact.descriptorForAllComparatorKeys()

/// settings from "Setting app - Contacts"
//CNContactsUserDefaults, CNContactsUserDefaults.shared().sortOrder
//---

// TODO: Merge duplicate https://stackoverflow.com/a/46023501
// TODO: progress callback https://developer.apple.com/documentation/foundation/progress
// TODO: manual Merge duplicate
// TODO: Merge all duplicate
// TODO: view all contacts controller
// TODO: backups controller


//let q = CNLabeledValue<NSString>.localizedString(forLabel: contactHomeAddress.label!)

///We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
//    var allowedContactKeys: [CNKeyDescriptor] {
//        return [
//            CNContactPhoneNumbersKey,
//            //CNContactEmailAddressesKey,
//            CNContactNamePrefixKey,
//            CNContactGivenNameKey,
//            CNContactFamilyNameKey,
//            //CNContactOrganizationNameKey,
//            //CNContactBirthdayKey,
//            //CNContactImageDataKey,
//            //CNContactThumbnailImageDataKey,
//            //CNContactImageDataAvailableKey
//            ] as [CNKeyDescriptor]
//        //+ [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
//    }

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

/// CNSaveRequest error:
/// CNError.Code.insertedRecordAlreadyExists
/// CNErrorUserInfoAffectedRecordsKey

/// https://developer.apple.com/documentation/contacts
/// https://github.com/satishbabariya/SwiftyContacts/blob/master/Sources/Core/SwiftyContacts.swift
/// Info.plist: NSContactsUsageDescription
/// Compound predicates in most fetches are not supported
final class ContactsManager: NSObject {
    
    static let shared = ContactsManager()
    
    let contactStore = CNContactStore()
    
    private let queue = DispatchQueue(label: "ContactsManagerQueue")
    
     override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(contactStoreDidChange), name: .CNContactStoreDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func contactStoreDidChange(_ notification: Notification) {
        
        print("---", notification)
        
        guard let userInfo = notification.userInfo else {
            return assertionFailure()
        }
        
        /// change outside the app
        if let isExtenralChanges = userInfo["CNNotificationOriginationExternally"] as? Bool, isExtenralChanges == true {
            // TODO: delegate refetch contacts
            
        } else { /// in app changes
            if let changedContactIdentifiers = userInfo["CNNotificationSaveIdentifiersKey"] as?  [String] {
                do {
                    let contact = try ContactsManager.shared.fetchContact(contactIdentifier: changedContactIdentifiers[0], keysToFetch: [ContactsManager.allContactKeys])
                    print(contact)
                } catch {
                    print(error)
                    print(error as NSError)
                    print(error.localizedDescription)
                }
                
            }
            //let contactStores = userInfo["CNNotificationSourcesKey"] as? [CNContactStore] /// tipicaly one item of ContactsManager 
        }
    }
    
    
    func create(name: String) {
        /// Creating a mutable object to add to the contact
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
        
        /// Saving the newly created contact
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        try? contactStore.execute(saveRequest)
    }
    
    /// handler will be execute on private queue
    func requestContactsAccess(handler: @escaping AccessStatusHandler) {
        queue.async { [weak self] in
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                handler(.success)
            case .denied, .restricted:
                handler(.denied)
            case .notDetermined:
                /// requestAccess exec completionHandler on own queue
                self?.contactStore.requestAccess(for: .contacts) { granted, _ in
                    self?.queue.async {
                        if granted {
                            handler(.success)
                        } else {
                            handler(.denied)
                        }
                    }
                }
            }
        }

    }
    
    static var allContactKeys: CNKeyDescriptor {
        return CNContactVCardSerialization.descriptorForRequiredKeys()
    }
    
    /// https://stackoverflow.com/q/32669612
    func fetchAllContacts(keysToFetch: [CNKeyDescriptor] = [ContactsManager.allContactKeys], completion: @escaping ContactsResult) {
        queue.async { [weak self] in
            guard let `self` = self else {
                return
            }
            var allContainers = [CNContainer]()
            
            do {
                allContainers = try self.contactStore.containers(matching: nil)
            } catch {
                completion(.failure(error))
            }
            
            var contacts = [CNContact]()
            
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                do {
                    let containerResults = try self.contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                    contacts.append(contentsOf: containerResults)
                } catch {
                    completion(.failure(error))
                }
            }
            
            completion(.success(contacts))
        }

    }
    
    public func fetchContacts(sortOrder: CNContactSortOrder, completion: @escaping ContactsResult) {
        queue.async { [weak self] in
            guard let `self` = self else {
                return
            }
            
            let fetchRequest = CNContactFetchRequest(keysToFetch: [ContactsManager.allContactKeys])
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = sortOrder
            
            //fetchRequest.predicate = 
            
            //if #available(iOS 10.0, *) {
            //    fetchRequest.mutableObjects = true
            //} else {
            //    
            //}
            
            do {
                var contacts = [CNContact]()
                try self.contactStore.enumerateContacts(with: fetchRequest) { contact, _ in
                    contacts.append(contact)   
                }
                completion(.success(contacts))
            } catch {
                completion(.failure(error))
            }
        }

    }
    
    public func fetchContacts(searchString: String, completion: @escaping ContactsResult) {
        queue.async { [weak self] in
            guard let `self` = self else {
                return
            }
            
            let predicate = CNContact.predicateForContacts(matchingName: searchString)
            do {
                let contacts = try self.contactStore.unifiedContacts(matching: predicate, keysToFetch: [ContactsManager.allContactKeys])
                completion(.success(contacts))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func fetchContacts(contactIdentifiers: [String], keysToFetch: [CNKeyDescriptor] = [ContactsManager.allContactKeys], completion: @escaping ContactsResult) {
        queue.async { [weak self] in
            guard let `self` = self else {
                return
            }
            
            let predicate: NSPredicate = CNContact.predicateForContacts(withIdentifiers: contactIdentifiers)
            do {
                let contacts = try self.contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                completion(.success(contacts))
            } catch {
                completion(.failure(error))
            }
        }

    }
    
    public func createContact(_ contact: CNMutableContact, containerIdentifier: String? = nil, completion: @escaping VoidResult) {
        queue.async { [weak self] in
            guard let `self` = self else {
                return
            }
            
            let request = CNSaveRequest()
            request.add(contact, toContainerWithIdentifier: containerIdentifier)
            do {
                try self.contactStore.execute(request)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func updateContact(_ contact: CNMutableContact, completion: @escaping VoidResult) {
        queue.async { [weak self] in
            guard let `self` = self else {
                return
            }
            
            let request = CNSaveRequest()
            request.update(contact)
            do {
                try self.contactStore.execute(request)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func deleteContact(_ contact: CNMutableContact, completion: @escaping VoidResult) {
        queue.async { [weak self] in
            guard let `self` = self else {
                return
            }
            
            let request = CNSaveRequest()
            request.delete(contact)
            do {
                try self.contactStore.execute(request)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    public func deleteContact(_ contact: CNContact, completion: @escaping VoidResult) {
        guard let deletingContact = contact.mutableCopy() as? CNMutableContact else {
            assertionFailure()
            completion(.failure(unknownError))
            return
        }
        deleteContact(deletingContact, completion: completion)
    }
    
    public func convertToVCard(contacts: [CNContact], completion: @escaping HandlerResult<Data>) {
        queue.async {
            do {
                let vcardFromContacts = try CNContactVCardSerialization.data(with: contacts)
                completion(.success(vcardFromContacts))
            } catch {
                completion(.failure(error))
            }
        }

    }
    
    public func convertToContacts(vCardData: Data, completion: @escaping ContactsResult) {
        queue.async {
            do {
                let contacts = try CNContactVCardSerialization.contacts(with: vCardData)
                completion(.success(contacts))
            } catch {
                completion(.failure(error))
            }
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
    
    public func fetchContact(contactIdentifier: String, keysToFetch: [CNKeyDescriptor]) throws -> CNContact {
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
    
    public func deleteContact(_ contact: CNContact) throws {
        guard let deletingContact = contact.mutableCopy() as? CNMutableContact else {
            assertionFailure()
            throw unknownError
        }
        try deleteContact(deletingContact)
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
    
    func findEmptyNameContacts() throws -> [CNContact] {
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        try contactStore.enumerateContacts(with: request) { contact, stop in
            if CNContactFormatter.string(from: contact, style: .fullName) == nil {
                contacts.append(contact)
            }
        }
        
        return contacts
    }
    
    /// can be create with return "String?" but without localized string
    func phoneOrEmailForNoNameContact(_ contact: CNContact) -> String {
        if contact.isKeyAvailable(CNContactPhoneNumbersKey), let phone = contact.phoneNumbers.first?.value.stringValue {
            return phone
        } else if contact.isKeyAvailable(CNContactEmailAddressesKey), let email = contact.emailAddresses.first?.value as String? {
            return email
        } else {
            return "No Name Phone Email"
        }
    }
    
    func delete(contacts: [CNContact]) throws {
        try contacts.forEach {
            try deleteContact($0)
        }
    }
    
    func deleteAllContacts() throws {
        let contacts = try fetchAllContacts(keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor])
        try delete(contacts: contacts)
    }
    
    func performOnQueue(_ handler: @escaping () -> Void) {
        queue.async(execute: handler)
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

