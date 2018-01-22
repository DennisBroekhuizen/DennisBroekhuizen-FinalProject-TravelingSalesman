//
//  ContactsViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 19-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  Search from tutorial: https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ContactsViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    // Declare array to load in all userscores.
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    
    // Refrence to leaderboard table in database.
    let ref = Database.database().reference(withPath: "users")
    
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.placeholder = "Search Constacts"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let currentUser = ref.child(self.userID!).child("contacts")

        currentUser.observe(.value, with: { snapshot in
            // Create array for new items in database.
            var newContacts: [Contact] = []
            
            for item in snapshot.children {
                // Declare and append elements from database to array
                let contact = Contact(snapshot: item as! DataSnapshot)
                newContacts.append(contact)
            }
            
            // Set new items to items array
            self.contacts = newContacts
            self.tableView.reloadData()
        })
        
        tableView.allowsSelection = false
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredContacts.count
        }
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Declare cell and items.
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        let loadedContacts: Contact?
        if isFiltering(){
            loadedContacts = filteredContacts[indexPath.row]
        } else {
            loadedContacts = contacts[indexPath.row]
        }
        
        // Set leaderboard items to cell elements.
        cell.nameLabel.text = loadedContacts?.name
        cell.addressLabel.text = loadedContacts?.address
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contactItem = contacts[indexPath.row]
            contactItem.ref?.removeValue()
        }
    }
    
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
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    // Segue to send user back to contactscreen.
    @IBAction func unwindToContactsScreen(segue: UIStoryboardSegue) {
    }
    
}

extension ContactsViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension ContactsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
