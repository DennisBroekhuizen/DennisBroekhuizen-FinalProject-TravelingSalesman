//
//  CurrentRouteViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 23-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  Current location tutorial: http://www.seemuapps.com/swift-get-users-location-gps-coordinates

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class CurrentRouteViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var openInMapsButton: UIButton!
    
    var geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    var myLocation: CLLocation?

    var currentRoute: [Route] = []
    var sectionTitles: [String] = ["Name", "Starting point", "Destinations"]
    var selectedAddress: String?
    var someLoc = CLLocation(latitude: 51.831953, longitude: 4.995684)
    let markerLocation = CLLocation(latitude: 51.83246670, longitude: 4.97659020)
    var sortedDestinations: [String] = []
    var destinationsCoordinates: [CLLocation] = [CLLocation(latitude: 51.571915, longitude: 4.768323),CLLocation(latitude: 51.504646, longitude: 3.891130), CLLocation(latitude: 50.851368, longitude: 5.690973), CLLocation(latitude: 53.219383, longitude: 6.566502), CLLocation(latitude: 53.164164, longitude: 5.781754), CLLocation(latitude: 52.160114, longitude: 4.497010)]
    
    // Refrence to leaderboard table in database.
    let ref = Database.database().reference(withPath: "users")
    
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
        
        // Open in Apple Maps button handling.
        openInMapsButton.isEnabled = false
        openInMapsButton.setTitle("Select address to open in maps",for: .normal)

        // Firebase.
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
            self.sortedDestinations = (newCurrentRoute.last?.destinations)!
            self.tableView.reloadData()
        })
        
        // Disable row selection.
        tableView.allowsSelection = false
    }
    
    func covertPlaceToCoor() {
        for destinations in sortedDestinations {
            geocoder.geocodeAddressString(destinations) {
                placemarks, error in
                let placemark = placemarks?.first?.location
                if let placemark = placemark {
                    self.destinationsCoordinates.append(placemark)
                }
            }
        }
        print("test")
        print(self.destinationsCoordinates)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
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
            cell.selectionStyle = .none
            return cell
        case 2:
            let destinationTitle = currentRoute.last?.destinations[indexPath.row]
            cell.textLabel?.text = destinationTitle
            tableView.allowsSelection = true
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    // Handling selection of rows in tableView.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        switch (indexPath.section) {
        case 2:
            selectedAddress = cell.textLabel?.text
            openInMapsButton.setTitle("Open address in maps",for: .normal)
            openInMapsButton.isEnabled = true
            print(selectedAddress!)
        default: break
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= 0 && section <= 3 {
            return sectionTitles[section]
        } else {
            return nil
        }
    }
    
    
    @IBAction func stopRouteDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Stop",
                                      message: "Are you sure you want to stop this route?",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        
                                        self.performSegue(withIdentifier: "stopRoute", sender: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapOpenInMaps(_ sender: Any) {
        let address = selectedAddress?.replacingOccurrences(of: " ", with: "")
        print(address!)
        UIApplication.shared.open(NSURL(string: "http://maps.apple.com/?address=\(address!)")! as URL, options: [:])
    }
    
    func viewDidDisappear() {
        let indexPath = tableView.indexPathForSelectedRow!
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            myLocation = location
            for (index, destination) in destinationsCoordinates.enumerated()  {
                if let myLocation = self.myLocation {
                    let afstand = myLocation.distance(from: destination)
                    print("De afstand van \(index) is \(afstand).")
                        if afstand < 100000 {
                            print("kleiner")
                            print(afstand)
                            let indexPath = IndexPath(row: index, section: 2)
                            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
                            cell.accessoryType = .checkmark
                        }
                }
            }
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "We need your location to check it with the addresses in your route.",
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
