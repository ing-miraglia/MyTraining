//
//  UserDefaults.swift
//  Cloudy
//
//  Created by Bart Jacobs on 03/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import Foundation

extension UserDefaults {

    // MARK: - Types
    
    private enum Keys {
        static let locations = "locations"
        static let currentLocation = "currentLocation"
    }
    
 
    // MARK: - Locations

    class var locations: [Location] {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.locations) else {
                return []
            }
            
            return (try? JSONDecoder().decode([Location].self, from: data)) ?? []
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            
            UserDefaults.standard.set(data, forKey: Keys.locations)
        }
    }

    class func addLocation(_ location: Location) {
        // Load Locations
        var locations = self.locations

        // Add Location
        locations.append(location)
        
        // Save Locations
        self.locations = locations
    }

    class func removeLocation(_ location: Location) {
        // Load Locations
        var locations = self.locations

        // Fetch Location Index
        guard let index = locations.firstIndex(of: location) else {
            return
        }

        // Remove Location
        locations.remove(at: index)

        // Save Locations
        self.locations = locations
    }
    
    class var currentLocation: Location? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.currentLocation) else {
                return nil
            }
            
            return try? JSONDecoder().decode(Location.self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            
            UserDefaults.standard.set(data, forKey: Keys.currentLocation)
        }
    }
    
}
