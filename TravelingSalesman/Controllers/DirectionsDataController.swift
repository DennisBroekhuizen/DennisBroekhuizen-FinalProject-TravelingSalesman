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
    func fetchDirections(completion: @escaping (Directions?) -> Void) {
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=Adelaide,SA&destination=Adelaide,SA&waypoints=optimize:true|Barossa+Valley,SA|Clare,SA|Connawarra,SA|McLaren+Vale,SA&key=AIzaSyDJsIT4pTNorLqY05njwn_qmC-KHYMK10o")!
        
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
