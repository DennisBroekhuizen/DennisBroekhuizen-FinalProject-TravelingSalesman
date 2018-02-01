//
//  TravelViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 22-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  ViewController to show a user their saved routes in Firebase if they have. User can select a route to start traveling with this route. Users can also delete routes from firebase.

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TravelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var noDateView: UIView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var sectionTitles: [String] = ["Routes"]
    var routes: [Route] = []
    
    // Firebase reference.
    let ref = Database.database().reference(withPath: "users")
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingView()
        getRoutesFromFirebase()
    }
    
    func showLoadingView() {
        if routes.count == 0 {
            tableView.backgroundView = loadingView
            // Remove row seperator line for tablerows.
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    func getRoutesFromFirebase() {
        let routesRef = ref.child(self.userID!).child("routes")
        
        routesRef.queryOrdered(byChild: "routes").observe(.value, with: { snapshot in
            // Create array for new routes in database.
            var newRoutes: [Route] = []
            
            for item in snapshot.children {
                // Declare and append elements from database to array.
                let route = Route(snapshot: item as! DataSnapshot)
                newRoutes.append(route)
            }
            
            // Set new routes to routes array.
            self.routes = newRoutes
            self.tableView.reloadData()
            self.updateTableViewBackground()
        })
    }
    
    func updateTableViewBackground() {
        if self.routes.count == 0 {
            self.tableView.backgroundView = self.noDateView
            self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        } else {
            self.tableView.backgroundView = nil
            self.tableView.tableFooterView = nil
        }
    }
    
    // MARK: - Table view setup.

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if routes.count == 0 {
            return 0
        } else if routes.count == 1 {
            return 1
        } else {
            return routes.count - 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath)
        
        let loadedRoutes = routes[indexPath.row]
        cell.textLabel?.text = loadedRoutes.name
        cell.detailTextLabel?.text = loadedRoutes.date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedRoute = routes[indexPath.row]
            selectedRoute.ref?.removeValue()
        }
    }
    
    // Pass data to next viewController.
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "showRoute" {
            let routeDetailViewController = segue.destination as! RouteDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedRoute = routes[indexPath.row]
            routeDetailViewController.chosenRoute = selectedRoute
        }
    }
    
    // Segue to send user back to loginscreen if they logout.
    @IBAction func unwindToTravelScreen(segue: UIStoryboardSegue) {
    }
    
}
