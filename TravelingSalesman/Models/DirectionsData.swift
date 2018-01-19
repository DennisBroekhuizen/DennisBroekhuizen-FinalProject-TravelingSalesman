//
//  DirectionsData.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 19-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import Foundation

struct Directions: Codable {
    let routes : [Routes]?
    let status : String?
    
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
    let copyrights : String?
    let summary : String?
    let warnings : [String]?
    let waypoint_order : [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case copyrights = "copyrights"
        case summary = "summary"
        case warnings = "warnings"
        case waypoint_order = "waypoint_order"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        copyrights = try values.decodeIfPresent(String.self, forKey: .copyrights)
        summary = try values.decodeIfPresent(String.self, forKey: .summary)
        warnings = try values.decodeIfPresent([String].self, forKey: .warnings)
        waypoint_order = try values.decodeIfPresent([String].self, forKey: .waypoint_order)
    }
    
}
