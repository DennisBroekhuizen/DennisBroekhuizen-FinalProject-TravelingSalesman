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
    var sectionTitles: [String] = ["Name", "Starting point", "Destinations", "End point"]
    var selectedAddress: String?
    var destinationsCoordinates: [CLLocation] = [CLLocation(latitude: 51.571915, longitude: 4.768323),CLLocation(latitude: 51.504646, longitude: 3.891130), CLLocation(latitude: 50.851368, longitude: 5.690973), CLLocation(latitude: 53.219383, longitude: 6.566502), CLLocation(latitude: 53.164164, longitude: 5.781754), CLLocation(latitude: 52.160114, longitude: 4.497010)]
    var desCoordinates: [CLLocation] = []
    
    // Refrence to leaderboard table in database.
    let ref = Database.database().reference(withPath: "users")
    
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
//        locationManager.requestAlwaysAuthorization()
//        // If location services is enabled get the users location
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
//            locationManager.startUpdatingLocation()
//            setUpGeofenceForPlayaGrandeBeach()
//        }
        
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
            // If location services is enabled get the users location
            let coordinates = self.currentRoute.last?.destinationsCoordinates
            if let coordinates = coordinates {
                self.desCoordinates = self.coordinatesToCLLocation(coordinates: coordinates)
            }
            if CLLocationManager.locationServicesEnabled() {
                self.setUpGeofenceForPlayaGrandeBeach()
                self.locationManager.startUpdatingLocation()
            }
            self.tableView.reloadData()
        })
        
//        let coordinates = currentRoute.last?.destinationsCoordinates
//        if let coordinates = coordinates {
//            print("hallo")
//            print(coordinates)
//            self.desCoordinates = coordinatesToCLLocation(coordinates: coordinates)
//            print(desCoordinates)
//        }
        
        // Disable row selection.
        tableView.allowsSelection = false
    }
    
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
    
    func setUpGeofenceForPlayaGrandeBeach() {
        print("hallo setting geofence")
        print(desCoordinates)
        for destination in desCoordinates {
            print("in de for loop")
//            let geofenceRegionCenter = CLLocationCoordinate2DMake(destination.);
            let geofenceRegion = CLCircularRegion(center: destination.coordinate, radius: 400, identifier: "Destination");
            geofenceRegion.notifyOnExit = false;
            geofenceRegion.notifyOnEntry = true;
            self.locationManager.startMonitoring(for: geofenceRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Welcome to Playa Grande! If the waves are good, you can try surfing!")
        //Good place to schedule a local notification
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if (status == CLAuthorizationStatus.authorizedAlways) {
//            self.setUpGeofenceForPlayaGrandeBeach()
//        }
//    }
    
    
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
//            cell.selectionStyle = .none
            tableView.allowsSelection = true
            return cell
        case 2:
            let destinationTitle = currentRoute.last?.destinations[indexPath.row]
            cell.textLabel?.text = destinationTitle
            tableView.allowsSelection = true
            return cell
        case 3:
            cell.textLabel?.text = currentRoute.last?.endPoint
//            cell.selectionStyle = .none
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
        UIApplication.shared.open(NSURL(string: "http://maps.apple.com/?address=\(address!)")! as URL, options: [:])
    }
    
    func viewDidDisappear() {
        let indexPath = tableView.indexPathForSelectedRow!
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
//            print(location.coordinate)
//            let coordinates = currentRoute.last?.destinationsCoordinates
//            if let coordinates = coordinates {
////                print("hallo")
////                print(coordinates)
//                self.desCoordinates = coordinatesToCLLocation(coordinates: coordinates)
////                print(desCoordinates)
//            }
            myLocation = location
            for (index, destination) in desCoordinates.enumerated()  {
                if let myLocation = self.myLocation {
                    let afstand = myLocation.distance(from: destination)
                    print("De afstand van \(index) is \(afstand).")
                        if afstand < 200 {
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