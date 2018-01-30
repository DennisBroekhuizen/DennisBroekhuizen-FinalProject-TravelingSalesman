//
//  Route.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 11-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  Struct of a route, to send routes between view controllers and save & retrieve routes from Firebase.

import Foundation
import FirebaseDatabase

struct Route {
    var name: String
    var date: String
    var startingPoint: String
    var destinations: [String]
    var destinationsCoordinates: [String]
    var endPoint: String
    let ref: DatabaseReference?
    
    init(name: String, date: String, startingPoint: String, destinations: [String], destinationsCoordinates: [String], endPoint: String) {
        self.name = name
        self.date = date
        self.startingPoint = startingPoint
        self.destinations = destinations
        self.destinationsCoordinates = destinationsCoordinates
        self.endPoint = endPoint
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        date = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        startingPoint = snapshotValue["startingPoint"] as! String
        destinations = snapshotValue["destinations"] as! [String]
        destinationsCoordinates = snapshotValue["destinationsCoordinates"] as! [String]
        endPoint = snapshotValue["endPoint"] as! String
        ref = snapshot.ref
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "nl_NL")
        return formatter
    }()
}
