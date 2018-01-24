//
//  CurrentRouteViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 23-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class CurrentRouteViewController: UITableViewController {
    
    @IBOutlet weak var openInMapsButton: UIButton!
    
    var geocoder = CLGeocoder()

    var currentRoute: [Route] = []
    var sectionTitles: [String] = ["Name", "Starting point", "Destinations"]
    var selectedAddress: String?
    
    // Refrence to leaderboard table in database.
    let ref = Database.database().reference(withPath: "users")
    
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Open in Apple Maps button handling.
        openInMapsButton.isEnabled = false
        openInMapsButton.setTitle("Select address to open in maps",for: .normal)

        // Firebase.
        let currentUser = ref.child(self.userID!).child("routes")
        currentUser.observe(.value, with: { snapshot in
            // Create array for new items in database.
            var newCurrentRoute: [Route] = []
            
            for item in snapshot.children {
                // Declare and append elements from database to array
                let route = Route(snapshot: item as! DataSnapshot)
                newCurrentRoute.append(route)
            }
            
            // Set new items to items array.
            self.currentRoute = newCurrentRoute
            self.tableView.reloadData()
        })
        
        // Disable row selection.
        tableView.allowsSelection = false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 2 {
            let lastRoute = currentRoute.last
            if let lastRoute = lastRoute {
                let lenDestination = lastRoute.destinations.count
                return lenDestination
            } else {
                return 0
            }
        } else {
            return 1
        }
    }
    
    // Declaration of tableView.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        switch (indexPath.section) {
        case 0:
            cell.textLabel?.text = currentRoute.last?.name
            cell.selectionStyle = .none
            return cell
        case 1:
            cell.textLabel?.text = currentRoute.last?.startingPoint
            cell.selectionStyle = .none
            return cell
        case 2:
            let destinationTitle = currentRoute.last?.destinations[indexPath.row]
            cell.textLabel?.text = destinationTitle
            tableView.allowsSelection = true
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    // Handling selection of rows in tableView.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        switch (indexPath.section) {
        case 2:
            cell.accessoryType = .checkmark
            selectedAddress = cell.textLabel?.text
            openInMapsButton.setTitle("Open address in maps",for: .normal)
            openInMapsButton.isEnabled = true
            print(selectedAddress!)
        default: break
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= 0 && section <= 3 {
            return sectionTitles[section]
        } else {
            return nil
        }
    }
    
    
    @IBAction func stopRouteDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Stop",
                                      message: "Are you sure you want to stop this route?",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        
                                        self.performSegue(withIdentifier: "stopRoute", sender: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapOpenInMaps(_ sender: Any) {
        let address = selectedAddress?.replacingOccurrences(of: " ", with: "")
        print(address!)
        UIApplication.shared.open(NSURL(string: "http://maps.apple.com/?address=\(address!)")! as URL, options: [:])
    }
    
    func viewDidDisappear() {
        let indexPath = tableView.indexPathForSelectedRow!
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
