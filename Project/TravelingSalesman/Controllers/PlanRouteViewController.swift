//
//  PlanRouteViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 15-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  Main view that let's a user plan a route. The user has to input a route name, date to travel with this route, has to choose a starting point, a minimum of one waypoint and an endpoint. Users can choose locations from their saved contacts or the Google Places API, handeled by the SearchViewController. After correctly filling in all fields, the user will be send to the OptimizeRouteViewController. In this ViewController the users route will be optimized by the Google Directions API. This will solve the traveling salesman problem.

import UIKit
import FirebaseAuth

class PlanRouteViewController: UITableViewController {
    
    @IBOutlet weak var footerView: UIView!
    
    // TableView variables.
    var sectionTitles: [String] = ["Name", "Date", "Starting point", "Waypoint(s)", "End point"]
    var sectionSelected: Int?
    var isPickerHidden = true
    
    // Variables of route.
    var routeName: String?
    var date: String?
    var startingPoint: String?
    var waypoints: [String] = []
    var waypointCoordinates: [String] = []
    var endPoint: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Change height for date cell when selected.
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        if indexPath == [1,0] {
            return isPickerHidden ? normalCellHeight: largeCellHeight
        } else {
            return normalCellHeight
        }
    }

    // Declaration of sections and rows in tableView.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return waypoints.count
        } else {
            return 1
        }
    }

    // Declaration of tableView.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "routeNameCell", for: indexPath) as! RouteNameCell
            cell.textField.delegate = self
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
            if date != nil {
                cell.dateLabel.text = date
            } else {
                cell.dateLabel.text = "Choose date"
            }
            
            cell.viewController = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectLocationCell", for: indexPath)
            if startingPoint != nil {
                cell.textLabel?.text = startingPoint
            } else {
                cell.textLabel?.text = "Choose starting point"
            }
            return cell
        case 3:
            let waypointTitle = waypoints[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "waypointCell", for: indexPath)
            cell.textLabel?.text = waypointTitle
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectLocationCell", for: indexPath)
            cell.textLabel?.text = "Add waypoint"
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectLocationCell", for: indexPath)
            if endPoint != nil {
                cell.textLabel?.text = endPoint
            } else {
                cell.textLabel?.text = "Choose end point"
            }
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    // Declaration of section titles in tableView.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= 0 && section <= 3 {
            return sectionTitles[section]
        } else if section == 5 {
            return sectionTitles.last
        } else {
            return nil
        }
    }
    
    // Handling selection of rows in tableView.
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            isPickerHidden = !isPickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
        case [2,0]:
            sectionSelected = 2
            self.performSegue (withIdentifier: "searchController", sender: self)
        case [4,0]:
            sectionSelected = 4
            if waypoints.count == 23 {
                reachedMaxWaypoints()
            } else {
                self.performSegue (withIdentifier: "searchController", sender: self)
            }
        case [5,0]:
            sectionSelected = 5
            self.performSegue (withIdentifier: "searchController", sender: self)
        default: break
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Allow user to only delete waypoints.
        if indexPath.section == 3 {
            return true
        } else {
            return false
        }
    }
    
    // Support deleting chosen waypoints from the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete waypoint and coordinates from array.
            waypoints.remove(at: indexPath.row)
            waypointCoordinates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Alert user when fields are empty.
    func validationCheckMessage() {
        let alert = UIAlertController(title: "Empty fields",
                                      message: "Please fill in all fields and a minimum of one waypoint.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func resetVariables() {
        let indexPathForRouteName = IndexPath(row: 0, section: 0)
        let routeNameCell = tableView.dequeueReusableCell(withIdentifier: "routeNameCell", for: indexPathForRouteName) as! RouteNameCell
        routeNameCell.textField.text = ""
        let indexPathForDateCell = IndexPath(row: 0, section: 1)
        let dateCell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPathForDateCell) as! DateCell
        dateCell.dateLabel.text = "Choose date"
        routeName = nil
        date = nil
        startingPoint = nil
        endPoint = nil
        waypoints = []
        waypointCoordinates = []
    }
    
    func reachedMaxWaypoints() {
        let alert = UIAlertController(title: "Maximum waypoints reached",
                                      message: "You can't add more than 23 waypoints.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Pass data to next OptimizeViewController to optimize route.
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "optimizeSegue" {
            // Check if all fields are filled in correctly.
            guard let routeName = routeName, routeName != "", let date = date,
                  let startingPoint = startingPoint, waypoints.count != 0, let endPoint = endPoint
                  else { validationCheckMessage(); return }
            
            // Pass planned route to next screen to optimize.
            let route = Route(name: routeName, date: date, startingPoint: startingPoint, destinations: waypoints, destinationsCoordinates: waypointCoordinates, endPoint: endPoint)
            let optimizeRouteViewController = segue.destination as! OptimizeRouteViewController
            optimizeRouteViewController.optimizedRoute = route
        }
    }
    
    // Perfrom segue to OptimizeViewController.
    @IBAction func planRouteTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "optimizeSegue", sender: nil)
    }
    
    // Unwind segue to PlanRouteViewController.
    @IBAction func unwindToPlanRoute(_ sender: UIStoryboardSegue) {
        
        // Retrieve data from the SearchViewController.
        if sender.source is SearchViewController {
            if let senderVC = sender.source as? SearchViewController {
                guard let chosenAddress = senderVC.chosenAddress else { return }
                if sectionSelected == 2 {
                    startingPoint = chosenAddress
                    tableView.reloadData()
                } else if sectionSelected == 4 {
                    waypoints.append(chosenAddress)
                    waypointCoordinates.append(senderVC.addressCoordinates)
                    let indexPath = IndexPath(row: waypoints.count - 1, section: 3)
                    tableView.beginUpdates()
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                } else if sectionSelected == 5 {
                    endPoint = chosenAddress
                    tableView.reloadData()
                }
            }
        }
        
        // Clear previous userinput if user saves a route.
        if sender.source is OptimizeRouteViewController {
            resetVariables()
            tableView.reloadData()
        }
    }
    
    // Show the user some generel information about the app.
    @IBAction func infoTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Info",
                                      message: "Plan routes with up to 23 locations, chosen from your contacts or Google Places. Travlr will optimize the most efficient waypoint order. After saving your route, you can start traveling by simpley selecting the route from the travel tab. From the started route you can open addresses with Apple Maps to help you navigate to your locations. It’s as easy as that.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Sing out user if the choose 'yes' in the alert.
    @IBAction func signOutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        // Try to logout.
                                        do {
                                            try Auth.auth().signOut()
                                            self.dismiss(animated: true, completion: nil)
                                        } catch {
                                            print("Something went wrong while logging out.")
                                        }
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
}

// Custom delegate to store textfield value after editing to save the route name.
extension PlanRouteViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        routeName = textField.text
    }
}
