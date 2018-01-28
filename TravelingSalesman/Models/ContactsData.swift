//
//  ContactsData.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 19-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Used to store contacts from database.
struct Contact {
    let name: String
    let address: String
    let coordinates: String
    let ref: DatabaseReference?
    
    init(snapshot: DataSnapshot) {
        name = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        address = snapshotValue["address"] as! String
        coordinates = snapshotValue["coordinates"] as! String
        ref = snapshot.ref
    }
}
