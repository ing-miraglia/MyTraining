//
//  AddLocationViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 06/07/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import Foundation
import CoreLocation

final class AddLocationViewModel {

    // MARK: - Properties

    var query: String = "" {
        didSet {
            geocode(addressString: query)
        }
    }
    
    // MARK: -

    private var querying = false {
        didSet {
            queryingDidChange?(querying)
        }
    }
    
    // MARK: -
    
    private var locations: [Location] = [] {
        didSet {
            locationsDidChange?(locations)
        }
    }

    var hasLocations: Bool {
        numberOfLocations > 0
    }
    
    var numberOfLocations: Int {
        locations.count
    }

    // MARK: -

    var queryingDidChange: ((Bool) -> ())?
    var locationsDidChange: (([Location]) -> ())?

    // MARK: -

    private lazy var geocoder = CLGeocoder()
    
    // MARK: - Public API
    
    func location(at index: Int) -> Location? {
        guard (0..<locations.count).contains(index) else {
            return nil
        }
        
        return locations[index]
    }

    func presentableForLocation(at index: Int) -> LocationPresentable? {
        guard let location = location(at: index) else {
            return nil
        }
        
        return LocationViewModel(location: location.location, locationAsString: location.name)
    }
    
    // MARK: - Helper Methods

    private func geocode(addressString: String?) {
        guard let addressString = addressString, !addressString.isEmpty else {
            // Reset Location
            locations = []
            
            return
        }
        
        // Update Helper
        querying = true
        
        // Geocode Address String
        geocoder.geocodeAddressString(addressString) { [weak self] (placemarks, error) in
            // Create Buffer
            var locations: [Location] = []
            
            // Update Helper
            self?.querying = false
            
            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")
            } else if let placemarks = placemarks {
                locations = placemarks.compactMap { (placemark) -> Location? in
                    guard let name = placemark.name else { return nil }
                    guard let location = placemark.location else { return nil }
                    return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
            }
            
            // Update Locations
            self?.locations = locations
        }
    }
    
}
