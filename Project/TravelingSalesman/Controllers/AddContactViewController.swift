//
//  AddContactViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 19-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  ViewController to let a user create and save contacts to Firebase.

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GooglePlaces

class AddContactViewController: UITableViewController {
    
    // Oulets of labels and button in view.
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactAddress: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // Variable to save coordinates of a chosen address from a contact.
    var contactCoordinates: String!
    
    // Firebase reference.
    let userID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable save button untill a user has filled in all fields.
        saveButton.isEnabled = false
        contactName.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        // Remove row seperator line for unfilled rows.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // Check if all fields are filled in correctly.
    @objc func editingChanged(_ textField: UITextField, textLabel: UILabel) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        if contactAddress.text == "Add address" {
            return
        }
        
        guard
            let name = contactName.text, !name.isEmpty
            else {
                saveButton.isEnabled = false
                return
        }
        saveButton.isEnabled = true
    }
    
    // Call Google Places API when selecting correct section row.
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        default: break
        }
    }
    
    func addContactToFirebase() {
        let contacts = self.ref.child(self.userID!).child("contacts")
        
        let newContact = contacts.child(self.contactName.text!)
        
        let post = ["address": self.contactAddress.text!,
                    "coordinates": self.contactCoordinates] as [String : Any]
        
        newContact.setValue(post)
    }
    
    // Ask the user to save a contact and store the contact to Firebase if they choose 'yes'.
    @IBAction func saveContactDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Save",
                                      message: "Are you sure you want to save this contact?",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        
                                        self.addContactToFirebase()
                                        self.performSegue(withIdentifier: "unwindToContacts", sender: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

// Google Places autocomplete API.
extension AddContactViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Enable savebutton if contact name isn't empty.
        if contactName.text != "" {
            saveButton.isEnabled = true
        }
        
        // Update address label in view.
        contactAddress.text = place.formattedAddress!
        contactCoordinates = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Print error to console.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

