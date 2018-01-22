//
//  SearchViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 22-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  Inspired by: https://github.com/gm6379/MapKitAutocomplete
//  https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class SearchViewController: UIViewController {
    
    // Declare array to load in all userscores.
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    var chosenAddress: String?
    
    // Refrence to leaderboard table in database.
    let ref = Database.database().reference(withPath: "users")
    
    let userID = Auth.auth().currentUser?.uid
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Address"
        searchController.searchBar.tintColor = UIColor.white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Online", "Contacts"]
        searchController.searchBar.delegate = self
        
        searchCompleter.delegate = self
        
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
        })
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredContacts = contacts.filter({( contact: Contact) -> Bool in
            if searchBarIsEmpty() {
                return true
            } else {
                return contact.name.lowercased().contains(searchText.lowercased())
            }
        })
        searchResultsTableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "unwindToPlanRoute" {
            print("test")
            let planRouteViewController = segue.destination as! PlanRouteViewController
            planRouteViewController.startingPoint = chosenAddress!
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            return searchResults.count
        } else {
            return filteredContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            let searchResult = searchResults[indexPath.row]
            cell.textLabel?.text = searchResult.title
            cell.detailTextLabel?.text = searchResult.subtitle
            return cell
        } else {
            let loadedContacts: Contact?
            if isFiltering(){
                loadedContacts = filteredContacts[indexPath.row]
            } else {
                loadedContacts = contacts[indexPath.row]
            }
            
            cell.textLabel?.text = loadedContacts?.name
            cell.detailTextLabel?.text = loadedContacts?.address
            return cell
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            let completion = searchResults[indexPath.row]
            
            let searchRequest = MKLocalSearchRequest(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                let coordinate = response?.mapItems[0].placemark.coordinate
                print(String(describing: coordinate))
            }
        }
        else {
            let loadedContacts: Contact!
            if isFiltering(){
                loadedContacts = filteredContacts[indexPath.row]
            } else {
                loadedContacts = contacts[indexPath.row]
            }
            chosenAddress = loadedContacts.address
            self.performSegue(withIdentifier: "unwindToPlanRoute", sender: nil)
            print(loadedContacts.address)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //        let searchBar = searchController.searchBar
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

