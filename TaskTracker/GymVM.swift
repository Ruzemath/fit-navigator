//
//  GymVM.swift
//  TaskTracker
//
//  Created by Ruzemath on 4/13/24.
//

import Foundation

struct Location: Decodable {
    let lat: Double
    let lng: Double
}

struct Place: Decodable {
    let name: String
    let geometry: Geometry
}

struct Geometry: Decodable {
    let location: Location
}

struct NearByGyms: Decodable {
    let results: [Place]
}

class GymVM : ObservableObject {
    @Published var gyms: [Place] = []
    
    func getJsonData(userLatitude: String, userLongitude: String) {
        
        // Make sure to add your Google Places API Key 
        let urlAsString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location="+userLatitude+"%2C"+userLongitude+"&radius=10000&type=gym&key=INSERT_API_KEY_HERE"
        
        let url = URL(string: urlAsString)!
        let urlSession = URLSession.shared
        
        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            var err: NSError?
            
            do {
                let decodedData = try JSONDecoder().decode(NearByGyms.self, from: data!)
                DispatchQueue.main.async {
                    self.gyms = decodedData.results
                }
            } catch {
                print("error: \(error)")
            }
        })
        jsonQuery.resume()
    }
}
