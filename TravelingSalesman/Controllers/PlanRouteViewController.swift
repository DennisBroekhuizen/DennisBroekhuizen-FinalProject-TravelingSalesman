//
//  PlanRouteViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 15-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit
import GooglePlaces

class PlanRouteViewController: UITableViewController {
    
    // TableView variables.
    var sectionTitles: [String] = ["Route name", "Date", "Starting point", "Waypoint(s)", "End point"]
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
        
        // Remove row seperator line for unfilled rows.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
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

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
            cell.dateLabel.text = Route.dateFormatter.string(for: cell.datePickerView.date)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "startingPointCell", for: indexPath) as! StartingPointCell
            if startingPoint != nil {
                cell.startingPointLabel.text = startingPoint
            }
            
            return cell
        case 3:
            let destinationTitle = waypoints[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCell", for: indexPath) as! DestinationCell
            cell.titleLabel.text = destinationTitle
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addDestinationCell", for: indexPath)
            
            return cell
        case 5:
//            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            let cell = tableView.dequeueReusableCell(withIdentifier: "startingPointCell", for: indexPath) as! StartingPointCell
            if endPoint != nil {
                cell.startingPointLabel.text = endPoint
            } else {
                cell.startingPointLabel.text = "Choose end point"
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
//            performGooglePLacesAutocomplete()
            self.performSegue (withIdentifier: "googlePlaces", sender: self)
        case [4,0]:
            sectionSelected = 4
//            performGooglePLacesAutocomplete()
            self.performSegue (withIdentifier: "googlePlaces", sender: self)
        case [5,0]:
            sectionSelected = 5
//            performGooglePLacesAutocomplete()
            self.performSegue (withIdentifier: "googlePlaces", sender: self)
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
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            waypoints.remove(at: indexPath.row)
            waypointCoordinates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Call Google Places API.
    func performGooglePLacesAutocomplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Alert user when fields are empty.
    func validationCheckMessage() {
        let alert = UIAlertController(title: "Please fill in all fields",
                                      message: "",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Pass data to next viewController.
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "optimizeSegue" {
            // Prepare to pass route name and date to next ViewController.
            let indexpathForRouteName = IndexPath(row: 0, section: 0)
            let indexpathForDate = IndexPath(row: 0, section: 1)
            let routeNameCell = tableView.cellForRow(at: indexpathForRouteName) as! RouteNameCell
            let dateCell = tableView.cellForRow(at: indexpathForDate) as! DateCell
            routeName = routeNameCell.textField.text
            date = dateCell.dateLabel.text
            
            // Check if all fields are filled in correctly.
            guard let routeName = routeName, routeName != "", let date = date,
                  let startingPoint = startingPoint, waypoints.count != 0, let endPoint = endPoint
                  else { validationCheckMessage(); return }
            
            // Pass planned route to next screen to optimize.
            let route = Route(name: routeName, date: date, startingPoint: startingPoint, destinations: waypoints, destinationsCoordinates: waypointCoordinates, endPoint: endPoint)
            let optimizeRouteViewController = segue.destination as! OptimizeRouteViewController
            optimizeRouteViewController.optimizedRoute = route
            print("De coordinaten: \(waypointCoordinates)")
        }
    }
    
    // Segue to send user back to PlanRouteViewController.
    @IBAction func unwindToPlanRoute(_ sender: UIStoryboardSegue) {
        if sender.source is SearchViewController {
            if let senderVC = sender.source as? SearchViewController {
                guard let chosenAddress = senderVC.chosenAddress else { return }
                if sectionSelected == 2 {
                    startingPoint = chosenAddress
                    tableView.reloadData()
                }
                if sectionSelected == 4 {
                    waypoints.append(chosenAddress)
                    waypointCoordinates.append(senderVC.addressCoordinates)
                    let indexPath = IndexPath(row: waypoints.count - 1, section: 3)
                    tableView.beginUpdates()
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
                if sectionSelected == 5 {
                    endPoint = chosenAddress
                    tableView.reloadData()
                }
            }
        }
    }
    
}

// Google Places autocomplete API.
extension PlanRouteViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Change starting point.
        if sectionSelected == 2 {
            startingPoint = place.formattedAddress!
            tableView.reloadData()
        }
        
        // Add waypoint to route.
        if sectionSelected == 4 {
            waypoints.append(place.formattedAddress!)
            waypointCoordinates.append("\(place.coordinate.latitude),\(place.coordinate.longitude)")
            let indexPath = IndexPath(row: waypoints.count - 1, section: 3)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
        // Change end point.
        if sectionSelected == 5 {
            endPoint = place.formattedAddress!
            tableView.reloadData()
        }
    
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
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
