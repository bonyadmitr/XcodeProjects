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
//                ContactsManager.shared.create(name: "111")
//                ContactsManager.shared.create(name: "222")
                
                //try? ContactsManager.shared.fetchContacts(sortOrder: .givenName)
                
//                ContactsManager.shared.fetchAllContacts { result in
//                    switch result {
//                    case .success(let contacts):
//                        print("contacts.count: ", contacts.count)
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
                
                do {
                    let duplicatesByName = try ContactsManager.shared.findDuplicateContacts()
                    
                    duplicatesByName.forEach({
                        self?.duplicatesByName.append($0)
                    })
                    self?.tableView.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            case .denied:
                print("denied")
            }
        }
    }
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
//        guard let cell = cell as? UITableViewCell else {
//            return
//        }
        
//        let duplicateByName = duplicatesByName[indexPath.section]
        
        cell.textLabel?.text = "\(indexPath.row + 1)"
//        cell.textLabel?.text = duplicateByName.contacts[indexPath.row].identifier
//        cell.detailTextLabel?.text = 
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contact = duplicatesByName[indexPath.section].contacts[indexPath.row]
        
        let keys = CNContactViewController.descriptorForRequiredKeys()
        guard let contactToView = try? ContactsManager.shared.fetchContacts(contactIdentifier: contact.identifier, keysToFetch: [keys]) else {
            return
        }
        let contactVC = CNContactViewController(for: contactToView)
        navigationController?.pushViewController(contactVC, animated: true)
        
        //contactVC.modalPresentationStyle = .formSheet
        //contactVC.allowsEditing = true
        //contactVC.contactStore =
//        contactVC.delegate = self
        
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
                return
            }
            let contact = self.duplicatesByName[indexPath.section].contacts[indexPath.row]
            do {
                try ContactsManager.shared.deleteContact(contact.mutableCopy() as! CNMutableContact)
                
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
            
//            let event = self?.fetchedResultsController.object(at: indexPath)
//            event?.delete()
        }
        return [action]
    }
}

extension ViewController: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
}
