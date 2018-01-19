//
//  PlannerViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 11-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit

class OptimizeRouteViewController: UITableViewController {

    var optimizedRoute: Route!
    var sectionTitles: [String] = ["Route name", "Date", "Starting point", "Destinations"]
    var optimizedArray: [String] = []
    let directionsDataController = DirectionsDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        directionsDataController.fetchDirections { (directions) in
//            if let directions = directions {
//                DispatchQueue.main.async {
//                    // Load API info into questions array.
//                    print(directions)
//                }
//            }
//        }
        
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
    
}
