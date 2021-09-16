//
//  WeatherDataState.swift
//  Cloudy
//
//  Created by Raffaele Miraglia on 09/09/21.
//  Copyright © 2021 Cocoacasts. All rights reserved.
//

import Foundation
enum WeatherDataState {
    case loading
    case data(WeatherData)
    case error(WeatherDataError)
    
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        case .data,
             .error:
            return false
        }
    }
    
    var weatherData: WeatherData? {
        switch self {
        case .data(let data):
            return data
        case .error,
             .loading:
            return nil
        }
    }
    
    var weatherDataError: WeatherDataError? {
        switch self {
        case .error(let error):
            return error
        case .loading,
             .data:
            return nil
        }
    }
}
