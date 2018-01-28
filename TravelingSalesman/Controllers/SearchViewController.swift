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
import FirebaseAuth
import FirebaseDatabase
import GooglePlaces


class SearchViewController: UIViewController {
    
    var searchController = UISearchController(searchResultsController: nil)

    // Declare array to load in all (filtered) contacts.
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    
    var chosenAddress: String!
    var addressCoordinates: String!
    
    // Refrence to leaderboard table in database.
    let ref = Database.database().reference(withPath: "users")
    let userID = Auth.auth().currentUser?.uid
    
    // Outlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.placeholder = "Search Contacts"
        // Put the search bar in the navigation bar.
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.delegate = self
        
        // Hide bottom border of navigation bar.
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
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
    
    
    @IBAction func segmentedIndexChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 1 {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
//        performSegue(withIdentifier: "unwindToPlanRoute", sender: nil)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //        let searchBar = searchController.searchBar
            filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredContacts.count
        }
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Declare cell and items.
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let loadedContacts: Contact?
        if isFiltering(){
            loadedContacts = filteredContacts[indexPath.row]
        } else {
            loadedContacts = contacts[indexPath.row]
        }
        
        // Set leaderboard items to cell elements.
        cell.textLabel?.text = loadedContacts?.name
        cell.detailTextLabel?.text = loadedContacts?.address
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isFiltering(){
            chosenAddress = filteredContacts[indexPath.row].address
            addressCoordinates = filteredContacts[indexPath.row].coordinates
        } else {
            chosenAddress = contacts[indexPath.row].address
            addressCoordinates = contacts[indexPath.row].coordinates
        }
        performSegue(withIdentifier: "unwindToPlanRoute", sender: nil)
    }
}

extension SearchViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        chosenAddress = place.formattedAddress!
        addressCoordinates = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
        dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: "unwindToPlanRoute", sender: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: "unwindToPlanRoute", sender: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
