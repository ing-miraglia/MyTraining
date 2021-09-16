//
//  Configuration.swift
//  Cloudy
//
//  Created by Bart Jacobs on 01/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import Foundation

enum Defaults {

    static let Latitude: Double = 51.400592
    static let Longitude: Double = 4.760970

}

struct WeatherServiceRequest {
    
    // MARK: - Properties
    
    private let apiKey = "tnperxfip8renk2hlzcccwetbnesby"
    private let baseUrl = URL(string: "https://cocoacasts.com/clearsky/")!
    private let fallBackUrl = URL(string: "https://cocoacasts.com/darksky/")!
    
    // MARK: -
    
    let latitude: Double
    let longitude: Double
    
    // MARK: - Public API
    var url: URL {
        url(for: baseUrl)
    }
    var falbackUrl: URL {
        url(for: fallBackUrl)
    }
    
    private func url(for baseUrl: URL) -> URL {
        // Create URL Components
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to Create URL Components for Weather Service Request")
        }
        
        // Define Query Items
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "long", value: "\(longitude)")
        ]
        
        guard let url = components.url else {
            fatalError("Unable to Create URL for Weather Service Request")
        }
        
        return url
    }
    
}
