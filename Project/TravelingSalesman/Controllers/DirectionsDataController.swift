//
//  DirectionsDataController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 19-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  Controller to optimize a route with the Google Directions API. The URL is depending on the users input.

import Foundation

class DirectionsDataController {
    func fetchDirections(startingPoint: String, destinations: [String], endPoint: String, completion: @escaping (Directions?) -> Void) {
        
        // Create URL with all locations from user input.
        var tempUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(startingPoint)&destination=\(endPoint)"
        
        // Add waypoint(s) to URL.
        tempUrl += "&waypoints=optimize:true%7c"
        for destination in destinations {
            tempUrl += destination + "%7c"
        }
        
        // Add API key to URL.
        tempUrl += "&key=AIzaSyDX7yfEqlktigCmvfMG6RgLEOqGXYLULwg"
        
        // Remove whitespace and convert string to URL.
        let noSpaceURL = tempUrl.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range:nil)
        
        // Replace accented characters with normal characters.
        let escapedURL = noSpaceURL.folding(options: .diacriticInsensitive, locale: .current)
        
        let url = URL(string: escapedURL)!

        // Perform API request.
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
