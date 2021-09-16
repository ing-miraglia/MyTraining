//
//  WeatherDataError.swift
//  Cloudy
//
//  Created by Bart Jacobs on 15/05/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

enum WeatherDataError: Error {

    // MARK: - Cases
    
    case notAuthorizedToRequestLocation
    case failedToRequestLocation
    case failedRequest
    case invalidResponse
}
