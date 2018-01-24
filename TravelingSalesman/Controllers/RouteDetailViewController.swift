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

class RouteDetailViewController: UITableViewController {
    
    var chosenRoute: Route!
    
    let userID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference(withPath: "users")

    var sectionTitles: [String] = ["Route name", "Date", "Starting point", "Destinations"]
//    var destinations: [String] = ["Amsterdam", "Rotterdam"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove row seperator line for unfilled rows.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // Declaration of sections and rows in tableView.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return chosenRoute.destinations.count
        } else {
            return 1
        }
    }
    
    // Declaration of tableView.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textElementCell", for: indexPath) as! TextElementCell
        switch (indexPath.section) {
        case 0:
            cell.textElementLabel.text = chosenRoute.name
            return cell
        case 1:
            cell.textElementLabel.text = chosenRoute.date
            return cell
        case 2:
            cell.textElementLabel.text = chosenRoute.startingPoint
            return cell
        case 3:
            cell.textElementLabel.text = chosenRoute.destinations[indexPath.row]
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
                                        
//                                        currentRoute.child("date").setValue(self.chosenRoute.date)
                                        
                                        currentRoute.child("name").setValue(self.chosenRoute.name)
                                        currentRoute.child("startingPoint").setValue(self.chosenRoute.startingPoint)
                                        currentRoute.child("destinations").setValue(self.chosenRoute.destinations)
                                        self.performSegue(withIdentifier: "startedRoute", sender: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}
