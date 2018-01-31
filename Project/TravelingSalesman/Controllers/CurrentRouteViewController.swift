//
//  CurrentRouteViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 23-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  This view controller will be presented when the user chooses to start a route from the RouteDetailViewController. The user will be asked to allow to share their location to compare it with the given waypoints in the route. Starting point and end point of the route won't be checked with the current location.
//
//  Current location tutorial: http://www.seemuapps.com/swift-get-users-location-gps-coordinates
//  Also used parts of this tutorial: https://medium.com/lateral-view/geofences-how-to-implement-virtual-boundaries-in-the-real-world-f3fc4a659d40

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class CurrentRouteViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var openInMapsButton: UIButton!
    
    // Declare location variables.
    var geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    var myLocation: CLLocation?

    // General variables.
    var currentRoute: [Route] = []
    var selectedAddress: String?
    var waypointsCoordinates: [CLLocation] = []
    var sectionTitles: [String] = ["Name", "Starting point", "Waypoint(s)", "End point"]
    
    // Firebase reference.
    let ref = Database.database().reference(withPath: "users")
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check and setup location manager.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Open in Apple Maps button handling.
        openInMapsButton.isEnabled = false
        openInMapsButton.setTitle("Select address to open in maps",for: .normal)

        getCurrentRouteFromFirebase()
        
        // Disable row selection.
        tableView.allowsSelection = false
    }
    
    func getCurrentRouteFromFirebase() {
        let currentUser = ref.child(self.userID!).child("routes")
        currentUser.observe(.value, with: { snapshot in
            // Create array for new items in database.
            var newCurrentRoute: [Route] = []
            
            for item in snapshot.children {
                // Declare and append elements from database to array
                let route = Route(snapshot: item as! DataSnapshot)
                newCurrentRoute.append(route)
            }
            
            // Set new items to items array.
            self.currentRoute = newCurrentRoute
            
            self.compareCurrentLocationWithWaypoints()
            self.tableView.reloadData()
        })
    }
    
    func compareCurrentLocationWithWaypoints() {
        // If location services is enabled get the users location
        let coordinates = self.currentRoute.last?.destinationsCoordinates
        if let coordinates = coordinates {
            self.waypointsCoordinates = self.coordinatesToCLLocation(coordinates: coordinates)
        }
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    // Convert waypoint coordinates retrieved from Firebase to CLLocation to check with users location.
    func coordinatesToCLLocation(coordinates: [String]) -> [CLLocation] {
        var convertedCoordinates: [CLLocation] = []
        for coordinate in coordinates {
            let lat = coordinate.components(separatedBy: ",")[0]
            let long = coordinate.components(separatedBy: ",")[1]
            if let latitude =  Double(lat), let longitude = Double(long) {
                convertedCoordinates.append(CLLocation(latitude: latitude, longitude: longitude))
            }
        }
        return convertedCoordinates
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 2 {
            let lastRoute = currentRoute.last
            if let lastRoute = lastRoute {
                let lenDestination = lastRoute.destinations.count
                return lenDestination
            } else {
                return 0
            }
        } else {
            return 1
        }
    }
    
    // Declaration of tableView.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        switch (indexPath.section) {
        case 0:
            cell.textLabel?.text = currentRoute.last?.name
            cell.selectionStyle = .none
            
            return cell
        case 1:
            cell.textLabel?.text = currentRoute.last?.startingPoint
            tableView.allowsSelection = true
            return cell
        case 2:
            let destinationTitle = currentRoute.last?.destinations[indexPath.row]
            cell.textLabel?.text = destinationTitle
            tableView.allowsSelection = true
            return cell
        case 3:
            cell.textLabel?.text = currentRoute.last?.endPoint
            tableView.allowsSelection = true
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    // Allow selection of location rows in tableView and abbilty to open location in Apple Maps.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        switch (indexPath.section) {
        case 1:
            selectedAddress = cell.textLabel?.text
            openInMapsButton.setTitle("Open address in maps",for: .normal)
            openInMapsButton.isEnabled = true
        case 2:
            selectedAddress = cell.textLabel?.text
            openInMapsButton.setTitle("Open address in maps",for: .normal)
            openInMapsButton.isEnabled = true
            print(selectedAddress!)
        case 3:
            selectedAddress = cell.textLabel?.text
            openInMapsButton.setTitle("Open address in maps",for: .normal)
            openInMapsButton.isEnabled = true
        default: break
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= 0 && section <= 4 {
            return sectionTitles[section]
        } else {
            return nil
        }
    }
    
    // Stop updating location if user chooses to stop route.
    @IBAction func stopRouteDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Stop",
                                      message: "Are you sure you want to stop this route?",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        self.locationManager.stopUpdatingLocation()
                                        self.performSegue(withIdentifier: "stopRoute", sender: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Open selected location from table view row in Apple Maps.
    @IBAction func didTapOpenInMaps(_ sender: Any) {
        // Convert address with illegal characters.
        let address = selectedAddress?.replacingOccurrences(of: " ", with: "")
        let escapedAddress = address?.folding(options: .diacriticInsensitive, locale: .current)
        UIApplication.shared.open(NSURL(string: "http://maps.apple.com/?address=\(escapedAddress!)")! as URL, options: [:])
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Info",
                                      message: "Checking your current location with given waypoint(s). Checkmarks will show if you did reach your waypoint(s).",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok",
                                         style: .default)
    
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Retrieve current location from user.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            myLocation = location
            // Check current location with all waypoint in route.
            for (index, destination) in waypointsCoordinates.enumerated()  {
                if let myLocation = self.myLocation {
                    let calculatedDistance = myLocation.distance(from: destination)
                    print("De afstand van \(index) is \(calculatedDistance).")
                    // If distance to waypoint is less than 200 meters of current location show checkmark
                    // in table view at specific waypoint row.
                    if calculatedDistance < 200 {
                        print("Reached waypoint")
                        let indexPath = IndexPath(row: index, section: 2)
                        guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
                        cell.accessoryType = .checkmark
                    }
                }
            }
        }
    }
    
    // If location tracking deined give the user the option to change it.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show popup to the user if location tracking is deined.
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Location Access Disabled",
                                                message: "We need your location to check it with the waypoints in your route.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
