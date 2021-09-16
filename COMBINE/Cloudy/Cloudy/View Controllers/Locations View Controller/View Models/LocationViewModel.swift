//
//  LocationViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 10/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import CoreLocation

struct LocationViewModel {

    // MARK: - Properties

    let location: CLLocation?
    let locationAsString: String?

    // MARK: - Initialization

    init(location: CLLocation? = nil, locationAsString: String? = nil) {
        // Set Properties
        self.location = location
        self.locationAsString = locationAsString
    }

}

extension LocationViewModel: LocationPresentable {

    var text: String {
        if let locationAsString = locationAsString {
            return locationAsString
        } else if let location = location {
            return location.toString
        }

        return "Unknown Location"
    }

}

extension CLLocation {

    var toString: String {
        let latitude = String(format: "%.3f", coordinate.latitude)
        let longitude = String(format: "%.3f", coordinate.longitude)
        return "\(latitude), \(longitude)"
    }

}
