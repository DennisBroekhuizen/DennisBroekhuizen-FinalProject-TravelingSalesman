//
//  RouteDetailViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 22-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  ViewController to show a user the details of a selected route from the TravelViewController. The user can choose to start traveling with the selected route in this ViewController. The current route will be pushed to Firebase.

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RouteDetailViewController: UITableViewController {
    
    var chosenRoute: Route!
    
    let userID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference(withPath: "users")

    var sectionTitles: [String] = ["Date", "Starting point", "Waypoint(s)", "End point"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation title to route name.
        navigationItem.title = "\(chosenRoute.name)"

        // Remove row seperator line for unfilled rows.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Disable selection of table view.
        tableView.allowsSelection = false
    }
    
    // MARK: - Setup table view.

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return chosenRoute.destinations.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch (indexPath.section) {
        case 0:
            cell.textLabel?.text = chosenRoute.date
            return cell
        case 1:
            cell.textLabel?.text = chosenRoute.startingPoint
            return cell
        case 2:
            cell.textLabel?.text = chosenRoute.destinations[indexPath.row]
            return cell
        case 3:
            cell.textLabel?.text = chosenRoute.endPoint
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= 0 && section <= 3 {
            return sectionTitles[section]
        } else {
            return nil
        }
    }
    
    // MARK: - Handle saving current route to Firebase.
    
    func addCurrentRouteToFirebase() {
        let currentUser = self.ref.child(self.userID!)
        
        let currentRoute = currentUser.child("routes").child("currentRoute")
        
        let post = ["name": self.chosenRoute.name,
                    "startingPoint": self.chosenRoute.startingPoint,
                    "destinations": self.chosenRoute.destinations,
                    "destinationsCoordinates": self.chosenRoute.destinationsCoordinates,
                    "endPoint": self.chosenRoute.endPoint] as [String : Any]
        
        currentRoute.setValue(post)
    }
    
    // Show message when user chooses to start route and add route to Firebase if they choose 'yes'.
    @IBAction func startButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Start",
                                      message: "Are you sure you want to start this route?",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        self.addCurrentRouteToFirebase()
                                        self.performSegue(withIdentifier: "startedRoute", sender: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
