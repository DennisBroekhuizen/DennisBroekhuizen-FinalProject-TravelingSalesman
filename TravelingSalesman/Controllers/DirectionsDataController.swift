//
//  DirectionsDataController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 19-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import Foundation

// Controller to retrieve questions from trivia api.
class DirectionsDataController {
    func fetchDirections(startingPoint: String, destinations: [String], endPoint: String, completion: @escaping (Directions?) -> Void) {
        var tempUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(startingPoint)&destination=\(endPoint)"
        
        tempUrl += "&waypoints=optimize:true%7c"
        
        for destination in destinations {
            tempUrl += destination + "%7c"
        }
        
        tempUrl += "&key=AIzaSyDX7yfEqlktigCmvfMG6RgLEOqGXYLULwg"
        let finalUrl = tempUrl.removingWhitespaces()
        print(finalUrl)
        let url = URL(string: finalUrl)!
        
//        let query: [String: String] = [
//        "api_key": "DEMO_KEY",
//        ]
//
//        let url = baseURL.withQueries(query)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let directions = try? jsonDecoder.decode(Directions.self, from: data) {
                completion(directions)
            } else {
                completion(nil)
                return
            }
        }
        task.resume()
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

