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

    var isPickerHidden = true
    var places: [String] = []
    var rowSelected: Int?
    var startingPoint: String = "Choose starting point"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        switch(indexPath) {
        case [1,0]: //Date Cell
            return isPickerHidden ? normalCellHeight:
            largeCellHeight
            
        default: return normalCellHeight
        }
    }

    // MARK: - Table view data source

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "routeNameCell", for: indexPath)

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            isPickerHidden = !isPickerHidden
//            DateCell.dateLabel.textColor = isPickerHidden ? .black : tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()
//            tableView.reloadData()
        case [2,0]:
            rowSelected = 2
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        case [4,0]:
            rowSelected = 4
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)

            print(places)
            
        default: break
        }
    }
    
}

extension PlanRouteViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Place cor: \(place.coordinate)")
        if rowSelected == 2 {
            print("starting point")
            startingPoint = place.formattedAddress!
            tableView.reloadData()
        }
        if rowSelected == 4 {
            places.append(place.formattedAddress!)
            let indexPath = IndexPath(row: places.count - 1, section: 3)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
        //        insertDestination()
        
        // Update startingPointLabel
//        startingPointLabel.text = place.formattedAddress
//        startingPointLabel.textColor = nil
        
//        destinationLabel.textColor = nil
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
