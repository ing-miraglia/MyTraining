//
//  Location.swift
//  Cloudy
//
//  Created by Bart Jacobs on 10/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Codable, Equatable {

    // MARK: - Properties

    let name: String?
    let latitude: Double
    let longitude: Double

    // MARK: -

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

}
