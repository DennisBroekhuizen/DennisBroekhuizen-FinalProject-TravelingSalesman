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

class OptimizeRouteViewController: UITableViewController {
    
    var optimizedRoute: Route!
    var sectionTitles: [String] = ["Route name", "Date", "Starting point", "Destinations"]
    var optimizedIndex: [Int] = []
    var optimizedDestinations: [String] = []
    let directionsDataController = DirectionsDataController()
    
    let userID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directionsDataController.fetchDirections(startingPoint: optimizedRoute.startingPoint, destinations: optimizedRoute.destinations) { (directions) in
            if let directions = directions {
                DispatchQueue.main.async {
                    // Load API info into questions array.
                    self.optimizedIndex = directions.routes![0].waypoint_order!
                    let lenDestinations = self.optimizedRoute.destinations.count - 1
                    
                    // Temp fill array
                    for i in 0 ... lenDestinations {
                        self.optimizedDestinations.append(String(i))
                    }
                    
                    for destination in 0 ... lenDestinations {
                        self.optimizedDestinations[destination] = self.optimizedRoute.destinations[self.optimizedIndex[destination]]
                    }
                    self.optimizedRoute.destinations = self.optimizedDestinations
                    self.tableView.reloadData()
//                    self.optimizedArray = directions.routes![0].waypoint_order!
//                    let lenArray = self.optimizedRoute.destinations.count
//                    var newArray: [String] = []
//                    for len in 0 ... lenArray - 1 {
//                        newArray.append(String(len))
//                    }
//                    print(newArray)
//                    for i in self.optimizedArray {
//                        newArray.insert(self.optimizedRoute.destinations[i], at: self.optimizedArray[i])
//                    }
//                    print(newArray)
//                    self.optimizedRoute.destinations = newArray
//                    self.tableView.reloadData()
//                    print(self.optimizedArray)
//                    print("test")
                }
            }
        }
        
        // Remove row seperator line for unfilled rows.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // Declaration of sections and rows in tableView.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        default: break
        }
        return UITableViewCell()
    }
    
    // Declaration of section titles in tableView.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= 0 && section <= 3 {
            return sectionTitles[section]
        } else {
            return nil
        }
    }
    
    @IBAction func saveButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Save",
                                      message: "Are you sure you want to save this route?",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        
                                        let currentUser = self.ref.child(self.userID!)
                                        
                                        let newRoute = currentUser.child("routes").child(self.optimizedRoute.date)
                                        
                                            newRoute.child("name").setValue(self.optimizedRoute.name)
                                        newRoute.child("startingPoint").setValue(self.optimizedRoute.startingPoint)
                                        newRoute.child("destinations").setValue(self.optimizedRoute.destinations)
                                        
//                                    self.performSegue(withIdentifier: "showTravel", sender: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}
