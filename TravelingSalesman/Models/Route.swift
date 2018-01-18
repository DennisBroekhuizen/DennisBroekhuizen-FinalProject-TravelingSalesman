//
//  Route.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 11-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import Foundation

struct Route {
    var name: String
    var date: String
    var startingPoint: String
    var destinations: [String]
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
