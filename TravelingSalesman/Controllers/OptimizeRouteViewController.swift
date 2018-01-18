//
//  PlannerViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 11-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit
import GooglePlaces

class OptimizeRouteViewController: UITableViewController {

    var optimizedRoute: Route!
    
    @IBOutlet weak var startingPointLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = optimizedRoute.date
        startingPointLabel.text = optimizedRoute.startingPoint
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if section == 3 {
//            return optimizedRoute.destinations.count
//        } else {
//            return 1
//        }
        return 1
    }
    
}
