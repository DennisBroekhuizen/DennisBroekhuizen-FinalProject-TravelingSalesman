//
//  OptimizeRouteViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 11-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  ViewController to optimize a route with the Google Directions API. This will solve the traveling salesman problem for the user. Users can store their route to Firebase.
//
//  Created an alert with delay when the user succesfully save their route. Code from: https://stackoverflow.com/questions/27613926/dismiss-uialertview-after-5-seconds-swift

import UIKit
import FirebaseAuth
import FirebaseDatabase

class OptimizeRouteViewController: UITableViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var sectionTitles: [String] = ["Route name", "Date", "Starting point", "Destinations", "End point"]
    
    // Route variables.
    var optimizedRoute: Route!
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
        
        let numberOfDestinations = optimizedRoute.destinations.count - 1
        
        // Temporary fill arrays so elements can be replaced with optimized index order from API.
        for i in 0 ... numberOfDestinations {
            self.optimizedDestinations.append(String(i))
            self.optimizedCoordinates.append(String(i))
        }
        
        // Google Directions API request.
        directionsDataController.fetchDirections(startingPoint: optimizedRoute.startingPoint, destinations: optimizedRoute.destinations, endPoint: optimizedRoute.endPoint) { (directions) in
            if let directions = directions {
                DispatchQueue.main.async {
                    
                    // Return if status of API isn't 'OK'.
                    if directions.status! != "OK" {
                        self.errorOptimize(status: directions.status!)
                        return
                    }
                    
                    // Retrieve optimized waypoint order from API.
                    let optimizedIndex = directions.routes![0].waypoint_order!
                    
                    // Replace temporary placeholders of arrays with real route data in optimized order.
                    for destination in 0 ... numberOfDestinations {
                        self.optimizedDestinations[destination] = self.optimizedRoute.destinations[optimizedIndex[destination]]
                        self.optimizedCoordinates[destination] = self.optimizedRoute.destinationsCoordinates[optimizedIndex[destination]]
                    }
                    
                    // Update route with optimized waypoints order.
                    self.optimizedRoute.destinations = self.optimizedDestinations
                    self.optimizedRoute.destinationsCoordinates = self.optimizedCoordinates
                    
                    // Show optimized order in table view and allow user to save route.
                    self.tableView.reloadData()
                    self.saveButton.isEnabled = true
                }
            } else {
                self.invalidRequest()
            }
        }
        
        // Remove row seperator line for unfilled rows.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.allowsSelection = false
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch (indexPath.section) {
        case 0:
            cell.textLabel?.text = optimizedRoute.name
            return cell
        case 1:
            cell.textLabel?.text = optimizedRoute.date
            return cell
        case 2:
            cell.textLabel?.text = optimizedRoute.startingPoint
            return cell
        case 3:
            cell.textLabel?.text = optimizedRoute.destinations[indexPath.row]
            return cell
        case 4:
            cell.textLabel?.text = optimizedRoute.endPoint
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
    
    func invalidRequest() {
        let alert = UIAlertController(title: "Invalid request",
                                      message: "One ore more of your locations are containing illegal characters or your route can't be optimized. Please choose other locations.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorMessage() {
        let alert = UIAlertController(title: "Oops", message: "Something went wrong while saving your route. Please try again.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func errorOptimize(status: String) {
        let alert = UIAlertController(title: "Oops", message: "This route can't be optimized. Make sure you did choose locations that can be travelled by car from each other. Status: \(status)", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func succesMessage() {
        let alert = UIAlertController(title: "", message: "Successfully saved your route!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "completionSegue", sender: nil)
        }
    }
    
    func saveRouteToFirebase() {
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
    }
    
    // Save route to Firebase if user chooses 'yes'.
    @IBAction func saveButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Save", message: "Are you sure you want to save this route?",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        let saveAction = UIAlertAction(title: "Yes", style: .default) { _ in
                         self.saveRouteToFirebase()
                         self.succesMessage()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
