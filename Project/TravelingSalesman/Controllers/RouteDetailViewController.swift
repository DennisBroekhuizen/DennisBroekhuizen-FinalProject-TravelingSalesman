//
//  RouteDetailViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 22-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class RouteDetailViewController: UITableViewController {
    
    var chosenRoute: Route!
    var distinationsCoordinates: [CLLocation] = []
    
    let userID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference(withPath: "users")

    var sectionTitles: [String] = ["Date", "Starting point", "Waypoint(s)", "End point"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "\(chosenRoute.name)"

        // Remove row seperator line for unfilled rows.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.allowsSelection = false
    }

    // Declaration of sections and rows in tableView.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // Setup the table view
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
    
    @IBAction func startButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Start",
                                      message: "Are you sure you want to start this route?",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        let saveAction = UIAlertAction(title: "Yes",
                         style: .default) { _ in
                                        
                        let currentUser = self.ref.child(self.userID!)
                                        
                        let currentRoute = currentUser.child("routes").child("currentRoute")
                                        
                        let post = ["name": self.chosenRoute.name,
                                    "startingPoint": self.chosenRoute.startingPoint,
                                    "destinations": self.chosenRoute.destinations,
                                    "destinationsCoordinates": self.chosenRoute.destinationsCoordinates,
                                    "endPoint": self.chosenRoute.endPoint] as [String : Any]
                    
                        currentRoute.setValue(post)
                                        
                        self.performSegue(withIdentifier: "startedRoute", sender: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }

}
