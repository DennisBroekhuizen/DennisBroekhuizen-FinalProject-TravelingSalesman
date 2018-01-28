//
//  PlannerViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 11-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class OptimizeRouteViewController: UITableViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var sectionTitles: [String] = ["Route name", "Date", "Starting point", "Destinations", "End point"]
    
    // Route variables.
    var optimizedRoute: Route!
    var optimizedIndex: [Int] = []
    var optimizedDestinations: [String] = []
    var optimizedCoordinates: [String] = []
    
    // Firebase reference.
    let userID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference(withPath: "users")
    
    // Google Directions API controller.
    let directionsDataController = DirectionsDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable save button until API is finised loading.
        saveButton.isEnabled = false
        
        directionsDataController.fetchDirections(startingPoint: optimizedRoute.startingPoint, destinations: optimizedRoute.destinations, endPoint: optimizedRoute.endPoint) { (directions) in
            if let directions = directions {
                DispatchQueue.main.async {
                    
                    if directions.status! != "OK" {
                        self.errorOptimize()
                        return
                    }
                    
                    // Retrieve optim
                    self.optimizedIndex = directions.routes![0].waypoint_order!
                    let lenDestinations = self.optimizedRoute.destinations.count - 1
                    
                    // Temp fill array
                    for i in 0 ... lenDestinations {
                        self.optimizedDestinations.append(String(i))
                        self.optimizedCoordinates.append(String(i))
                    }
                    
                    for destination in 0 ... lenDestinations {
                        self.optimizedDestinations[destination] = self.optimizedRoute.destinations[self.optimizedIndex[destination]]
                        self.optimizedCoordinates[destination] = self.optimizedRoute.destinationsCoordinates[self.optimizedIndex[destination]]
                    }
                    
                    self.optimizedRoute.destinations = self.optimizedDestinations
                    self.optimizedRoute.destinationsCoordinates = self.optimizedCoordinates
                    self.tableView.reloadData()
                    self.saveButton.isEnabled = true
                }
            }
        }
        
        // Remove row seperator line for unfilled rows.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // Declaration of sections and rows in tableView.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return optimizedRoute.destinations.count
        } else {
            return 1
        }
    }
    
    // Declaration of tableView.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! TextLabelCell
        switch (indexPath.section) {
        case 0:
            cell.labelText.text = optimizedRoute.name
            return cell
        case 1:
            cell.labelText.text = optimizedRoute.date
            return cell
        case 2:
            cell.labelText.text = optimizedRoute.startingPoint
            return cell
        case 3:
            cell.labelText.text = optimizedRoute.destinations[indexPath.row]
            return cell
        case 4:
            cell.labelText.text = optimizedRoute.endPoint
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    // Declaration of section titles in tableView.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= 0 && section <= 4 {
            return sectionTitles[section]
        } else {
            return nil
        }
    }
    
    func errorMessage() {
        let alert = UIAlertController(title: "Oops", message: "Something went wrong while saving your route. Please try again.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func errorOptimize() {
        let alert = UIAlertController(title: "Oops", message: "Your route can't be optimized.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Save", message: "Are you sure you want to save this route?",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        let saveAction = UIAlertAction(title: "Yes", style: .default) { _ in
                         guard let optimizedRoute = self.optimizedRoute
                               else { self.errorMessage(); return }
            
                         let currentUser = self.ref.child(self.userID!)
                                        
                         let newRoute = currentUser.child("routes").child(optimizedRoute.date)
                                        
                         let post = ["name": optimizedRoute.name,
                                     "startingPoint": optimizedRoute.startingPoint,
                                     "destinations": optimizedRoute.destinations,
                                     "destinationsCoordinates": optimizedRoute.destinationsCoordinates,
                                     "endPoint": optimizedRoute.endPoint] as [String : Any]
            
                         newRoute.setValue(post)
//                                    self.performSegue(withIdentifier: "showTravel", sender: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
