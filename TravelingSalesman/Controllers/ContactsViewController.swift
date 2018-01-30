//
//  ContactsViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 19-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  SearchViewController to show a user their contacts. Let them create and delete contacts from and to firebase. Users are also able to search for contacts. Search tutorial from: https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ContactsViewController: UITableViewController {
    
    // Outlets to change backgroud of table view.
    @IBOutlet var noContactsView: UIView!
    @IBOutlet var loadingContactsView: UIView!
    
    // Arrays to load in contacts and filtered contacts.
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    
    // Declare searchcontroller.
    let searchController = UISearchController(searchResultsController: nil)
    
    // Reference to Firebase.
    let ref = Database.database().reference(withPath: "users")
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show loading view as long as the contacts aren't loaded.
        if contacts.count == 0 {
            tableView.backgroundView = loadingContactsView
            // Remove row seperator line for tablerows.
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.placeholder = "Search Contacts"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Retrieve contacts from Firebase.
        let currentUser = ref.child(self.userID!).child("contacts")
        currentUser.observe(.value, with: { snapshot in
            // Create array for new items in database.
            var newContacts: [Contact] = []
            
            for item in snapshot.children {
                // Declare and append elements from database to array
                let contact = Contact(snapshot: item as! DataSnapshot)
                newContacts.append(contact)
            }
            
            // Set new contacts to contacts array.
            self.contacts = newContacts
            self.tableView.reloadData()
            
            // Show no contacts view if users haven't stored contacts in firebase.
            if self.contacts.count == 0 {
                self.tableView.backgroundView = self.noContactsView
                self.tableView.tableFooterView = UIView(frame: CGRect.zero)
            } else {
                // Clear background view if contacts are loaded.
                self.tableView.backgroundView = nil
                self.tableView.tableFooterView = nil
            }
        })
        
        // Disable table view selection.
        tableView.allowsSelection = false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Return rows depending on users search input.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredContacts.count
        } else {
            return contacts.count
        }
    }
    
    // Declare cells in table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let loadedContacts: Contact?
        
        // Return contacts depending on search filtering.
        if isFiltering(){
            loadedContacts = filteredContacts[indexPath.row]
        } else {
            loadedContacts = contacts[indexPath.row]
        }
        
        // Set contacts to cell elements.
        cell.textLabel?.text = loadedContacts?.name
        cell.detailTextLabel?.text = loadedContacts?.address
        return cell
    }
    
    // Allow user to delete contacts from table view and Firebase.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contactItem = contacts[indexPath.row]
            contactItem.ref?.removeValue()
        }
    }
    
    // Return contacts depending on users searchterm and reload table view.
    func filterContentForSearchText(_ searchText: String) {
        filteredContacts = contacts.filter({( contact: Contact) -> Bool in
            if searchBarIsEmpty() {
                return true
            } else {
                return contact.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    // Check if searchbar is empty.
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Check for filtering.
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // Segue to send user back to contactscreen.
    @IBAction func unwindToContactsScreen(segue: UIStoryboardSegue) {
    }
}

extension ContactsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
