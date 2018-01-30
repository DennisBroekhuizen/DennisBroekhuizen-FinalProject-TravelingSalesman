//
//  DirectionsData.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 19-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  Structure used for storing elements from Google Directions API.

import Foundation

struct Directions: Codable {
    let routes: [Routes]?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        
        case routes = "routes"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        routes = try values.decodeIfPresent([Routes].self, forKey: .routes)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Routes: Codable {
    let waypoint_order : [Int]?
    
    enum CodingKeys: String, CodingKey {
        case waypoint_order = "waypoint_order"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        waypoint_order = try values.decodeIfPresent([Int].self, forKey: .waypoint_order)
    }
}
