//
//  NoNameContactsController.swift
//  ContactsManager
//
//  Created by Bondar Yaroslav on 9/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI


final class NoNameContactsController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
        }
    }
    
    private var noNameContacts = [CNContact]() 
    private var noNameContactsDisplayName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Contacts"
        navigationItem.backBarButtonItem = backItem
        
        fetchContacts()
    }
    
    private func fetchContacts() {
        ContactsManager.shared.requestContactsAccess { [weak self] status in
            switch status {
            case .success:
                print("success")
                
                do {
                    let noNameContacts = try ContactsManager.shared.findEmptyNameContacts()
                    self?.noNameContacts = noNameContacts
                    self?.noNameContactsDisplayName = noNameContacts.map { ContactsManager.shared.phoneOrEmailForNoNameContact($0) }
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } catch {
                    assertionFailure(error.localizedDescription)
                }
                
            case .denied:
                print("denied")
            }
        }
    }
    
    // TODO: UI block or guard on cell selection
    @IBAction private func deleteAllNoNameContacts(_ sender: UIBarButtonItem) {
        ContactsManager.shared.performOnQueue { [weak self] in
            guard let `self` = self else {
                return
            }
            
            do {
                try ContactsManager.shared.delete(contacts: self.noNameContacts)
                self.noNameContacts.removeAll()
                self.noNameContactsDisplayName.removeAll()
                
                DispatchQueue.main.async { 
                    self.tableView.reloadData()
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

extension NoNameContactsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noNameContactsDisplayName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    }
}

extension NoNameContactsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = noNameContactsDisplayName[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contact = noNameContacts[indexPath.row]
        let keys = CNContactViewController.descriptorForRequiredKeys()
        
        do {
            let contactToView = try ContactsManager.shared.fetchContact(contactIdentifier: contact.identifier, keysToFetch: [keys])
            
            /// must be pushed
            let contactVC = CNContactViewController(for: contactToView)
            contactVC.contactStore = ContactsManager.shared.contactStore
            navigationController?.pushViewController(contactVC, animated: true)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in
            guard let `self` = self else {
                return assertionFailure()
            }
            let deletingContact = self.noNameContacts[indexPath.row]
            do {
                try ContactsManager.shared.deleteContact(deletingContact)
                self.noNameContacts.remove(at: indexPath.row)
                self.noNameContactsDisplayName.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        return [action]
    }
}
