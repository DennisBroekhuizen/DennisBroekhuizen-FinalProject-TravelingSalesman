//
//  SearchViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 22-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  SearchViewController to let a user choose locations when planning a route. Locations can be selected from saved contacts in Firebase or the Google Places API. Contacts search tutorial from: https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GooglePlaces

class SearchViewController: UIViewController {

    // Declare array to load in all (filtered) contacts.
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    
    // Declare search controller.
    var searchController = UISearchController(searchResultsController: nil)
    
    // Variables to save addresses and coordinates.
    var chosenAddress: String!
    var addressCoordinates: String!
    
    // Reference to Firebase.
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
        searchController.searchBar.showsCancelButton = true
        definesPresentationContext = true
        
        // Put the search bar in the navigation bar.
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        
        // Prevent the navigation bar from being hidden when searching.
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        // Hide bottom border of navigation bar.
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Retrieve contacts from Firebase.
        let currentUser = ref.child(self.userID!).child("contacts")
        
        currentUser.observe(.value, with: { snapshot in
            // Create array for new contacts in database.
            var newContacts: [Contact] = []
            
            for item in snapshot.children {
                // Declare and append elements from database to array
                let contact = Contact(snapshot: item as! DataSnapshot)
                newContacts.append(contact)
            }
            
            // Set new contacts to contacts array
            self.contacts = newContacts
            self.tableView.reloadData()
        })
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
    
    // Call Google Places API when segmented index changed.
    @IBAction func segmentedIndexChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 1 {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    // Dismiss table view when cancel button is clicked.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
            filterContentForSearchText(searchController.searchBar.text!)
    }
}

// MARK: - Table view data source.
extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return rows depending on users search input.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredContacts.count
        }
        return contacts.count
    }
    
    // Declare cells in table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
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
}

// Handle selection of contact and pefrom segue back to PlanRouteViewController with chosen address.
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

// Google Places API.
extension SearchViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Declare chosen address and perfrom segue back to PlanRouteViewController with chosen address.
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
