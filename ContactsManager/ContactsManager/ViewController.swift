//
//  ViewController.swift
//  ContactsManager
//
//  Created by Bondar Yaroslav on 9/21/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
        }
    }
    
    private var duplicatesByName = [(name: String, contacts: [CNContact])]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Contacts"
        navigationItem.backBarButtonItem = backItem
        
        ContactsManager.shared.requestContactsAccess { [weak self] status in
            switch status {
            case .success:
                print("success")
                
                do {
                    let duplicatesByName = try ContactsManager.shared.findDuplicateContacts()
                    
                    duplicatesByName.forEach({
                        self?.duplicatesByName.append($0)
                    })
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            case .denied:
                print("denied")
            }
        }
    }
    
    @IBAction private func sendEmail(_ sender: UIBarButtonItem) {
        do {
            let contacts = try ContactsManager.shared.fetchAllContacts()
            let vCardData = try ContactsManager.shared.convertToVCard(contacts: contacts)
            
            let attachment = MailAttachment(data: vCardData, mimeType: "text/vcard", fileName: "contacts.vcf")
            
            EmailSender.shared.send(message: "",
                                    subject: "ContactsManager",
                                    to: ["zdaecq@gmail.com"],
                                    attachments: [attachment],
                                    presentIn: self)
            
        } catch {
            print("sendEmail error: ", error.localizedDescription)
        }
    }
    
    @IBAction private func showPicker(_ sender: UIBarButtonItem) {
        /// must be presented
        /// implementing one of two delegate methods will configure the picker for multi-selection
        let picker = CNContactPickerViewController()
        
        /// If not set all properties are displayed
        /// if set "[]" none properties are displayed
        /// usefull only for delegate method:
        /// "func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty"
        picker.displayedPropertyKeys = [CNContactEmailAddressesKey]
        
        /// If not set all contacts are selectable
        picker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        
        /// It determines whether a selected contact should be returned (predicate evaluates to TRUE)
        /// or if the contact detail card should be displayed (evaluates to FALSE).
        /// If not set the picker displays the contact detail card when the contact is selected. !!! NOT TRUE !!!
        ///
        /// usefull only for delegate method:
        /// "func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact)"
        /// in this case "picker.displayedPropertyKeys" can be usefull too
        picker.predicateForSelectionOfContact = NSPredicate(format: "emailAddresses.@count > 0")
        //picker.predicateForSelectionOfContact = NSPredicate(value: false)
        
        /// It determines whether a selected property should be returned (predicate evaluates to TRUE)
        /// or if the default action for the property should be performed (predicate evaluates to FALSE).
        /// If not set the picker returns the first selected property.
        /// The predicate is evaluated on the CNContactProperty that is being selected.
        ///
        /// if you don't need extra predicate like "value LIKE '*@apple.com'"
        /// better don't show others options(contact keys) by setting "picker.displayedPropertyKeys = [KEYS]"
//        picker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'emailAddresses'")
        
        picker.delegate = self  
        present(picker, animated: true, completion: nil)  
    }  
    
    //#MARK: CNContactPickerDelegate methods  
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return duplicatesByName.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duplicatesByName[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = "\(indexPath.row + 1)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contact = duplicatesByName[indexPath.section].contacts[indexPath.row]
        let keys = CNContactViewController.descriptorForRequiredKeys()
        
        guard let contactToView = try? ContactsManager.shared.fetchContact(contactIdentifier: contact.identifier, keysToFetch: [keys]) else {
            return assertionFailure()
        }
        
        /// this init don't need. it's like "CNContactViewController(for" with ".allowsEditing = false"
        //let contactVC = CNContactViewController(forUnknownContact: contactToView)
        
        /// must be presented
//        let contactVC = CNContactViewController(forNewContact: contactToView)
        
        /// must be pushed
        let contactVC = CNContactViewController(for: contactToView)
        
//        contactVC.delegate = self
        //contactVC.modalPresentationStyle = .formSheet
        contactVC.allowsEditing = false
//        contactVC.allowsActions = false /// "Send Message", "Share Contact", etc
        
        /// The contact store from which the contact was fetched or to which it will be saved
        contactVC.contactStore = ContactsManager.shared.contactStore
        
        navigationController?.pushViewController(contactVC, animated: true)
        
//        let navVC = UINavigationController(rootViewController: contactVC)
//        present(navVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return duplicatesByName[section].name
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        /// weak?
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in
            guard let `self` = self else {
                return assertionFailure()
            }
            let contact = self.duplicatesByName[indexPath.section].contacts[indexPath.row]
            do {
                try ContactsManager.shared.deleteContact(contact)
                
                if self.duplicatesByName[indexPath.section].contacts.count > 2 {
                    self.duplicatesByName[indexPath.section].contacts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    self.duplicatesByName.remove(at: indexPath.section)
                    self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        return [action]
    }
}

extension ViewController: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        if let contact = contact {
            print(contact)
        } else { /// edit canceled by user
            print("edit canceled by user")
        }
//        viewController.dismiss(animated: true, completion: nil)
    }
    
    /// allow tap on phone to call and etc.
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
}

extension ViewController: CNContactPickerDelegate {
    
    /// The picker will be dismissed automatically after a contact or property is picked.
//    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
//        print("--- contactPickerDidCancel")
//    }
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//        print("--- didSelect contact", contact)
//    }
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
//        print("--- didSelect contactProperty", contactProperty)
//    }
    
    /// implementing this method will configure the picker for multi-selection
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        print("--- didSelect contacts", contacts)
    }
    
    /// implementing this method will configure the picker for multi-selection
//    func contactPicker(_ picker: CNContactPickerViewController, didSelectContactProperties contactProperties: [CNContactProperty]) {  
//        print("--- contactProperties: ", contactProperties)  
//    }
}
