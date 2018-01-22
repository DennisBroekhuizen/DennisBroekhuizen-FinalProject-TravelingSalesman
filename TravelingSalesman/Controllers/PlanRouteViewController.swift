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
    
    // Declaration of variables.
    var sectionTitles: [String] = ["Route name", "Date", "Starting point", "Destinations"]
    var sectionSelected: Int?
    var isPickerHidden = true
    var routeName: String?
    var date: String?
    var startingPoint: String = "Choose starting point"
    var places: [String] = []
    
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
        
        switch(indexPath) {
        case [1,0]:
            return isPickerHidden ? normalCellHeight: largeCellHeight
        default: return normalCellHeight
        }
    }

    // Declaration of sections and rows in tableView.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return places.count
        } else {
            return 1
        }
    }

    // Declaration of tableView.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "routeNameCell", for: indexPath) as! RouteNameCell
            cell.configure(text: "")
            routeName = cell.textField.text

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
            cell.dateLabel.text = Route.dateFormatter.string(for: cell.datePickerView.date)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "startingPointCell", for: indexPath) as! StartingPointCell
            cell.startingPointLabel.text = startingPoint
            
            return cell
        case 3:
            let destinationTitle = places[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCell", for: indexPath) as! DestinationCell
            cell.titleLabel.text = destinationTitle
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addDestinationCell", for: indexPath)
            
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
//            let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//            present(autocompleteController, animated: true, completion: nil)
            self.performSegue (withIdentifier: "showSearch", sender: self)
        case [4,0]:
            sectionSelected = 4
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
            
        default: break
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Pass data to next viewController.
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "optimizeSegue" {
            let indexpathForRouteName = IndexPath(row: 0, section: 0)
            let indexpathForDate = IndexPath(row: 0, section: 1)
            let routeNameCell = tableView.cellForRow(at: indexpathForRouteName) as! RouteNameCell
            let dateCell = tableView.cellForRow(at: indexpathForDate) as! DateCell
            let route = Route(name: routeNameCell.textField.text!, date: dateCell.dateLabel.text!, startingPoint: startingPoint, destinations: places)
            let optimizeRouteViewController = segue.destination as! OptimizeRouteViewController
            optimizeRouteViewController.optimizedRoute = route
        }
    }
    
    // Segue to send user back to planRouteViewController.
    @IBAction func unwindToPlanRoute(segue: UIStoryboardSegue) {
    }
    
}

// Google Places autocomplete API.
extension PlanRouteViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        // Change starting point.
        if sectionSelected == 2 {
            print("starting point")
            startingPoint = place.formattedAddress!
            tableView.reloadData()
        }
        
        // Add destination to route.
        if sectionSelected == 4 {
            places.append(place.formattedAddress!)
            let indexPath = IndexPath(row: places.count - 1, section: 3)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
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
