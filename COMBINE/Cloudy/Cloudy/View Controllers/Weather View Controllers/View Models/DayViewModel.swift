//
//  DayViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 21/05/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit
import Combine

final class DayViewModel: WeatherViewModel {

    // MARK: - Properties    
    private var  weatherDataPublisher: AnyPublisher<WeatherData,Never> {
        weatherDataStatePublisher
            .compactMap{$0.weatherData}
            .eraseToAnyPublisher()
    }

    // MARK: - Public API
    
    var datePublisher: AnyPublisher<String?,Never> {
        let dateFormatter = DateFormatter()

        // Configure Date Formatter
        dateFormatter.dateFormat = "EEE, MMMM d"

        return weatherDataPublisher
            .map {dateFormatter.string(from: $0.time)}
            .eraseToAnyPublisher()
    }

    var timePublisher: AnyPublisher<String?,Never> {
        let dateFormatter = DateFormatter()
        return weatherDataPublisher.combineLatest(timeNotationPublisher)
            .map {weatherData, timeNotation -> String? in
                dateFormatter.dateFormat = timeNotation.dateFormat
                return dateFormatter.string(from: weatherData.time)
            }
            .eraseToAnyPublisher()
    }
    
    var summaryPublisher: AnyPublisher<String?,Never> {
        return weatherDataPublisher
            .map { $0.summary }
            .eraseToAnyPublisher()
    }
    var temperaturePublisher: AnyPublisher<String?,Never> {
        weatherDataPublisher.combineLatest(temperatureNotationPublisher)
            .map { weatherData,temperatureNotation -> String? in
                switch temperatureNotation {
                case .fahrenheit:
                    return String(format: "%.1f °F", weatherData.temperature)
                case .celsius:
                    return String(format: "%.1f °C", weatherData.temperature.toCelcius)
                }
            }
            .eraseToAnyPublisher()
    }
 
    var windSpeedPublisher: AnyPublisher<String?,Never> {
        weatherDataPublisher.combineLatest(unitNotationPublisher)
            .map { weatherData,unitsNotation -> String? in
                switch unitsNotation {
                case .imperial:
                    return String(format: "%.f MPH", weatherData.windSpeed)
                case .metric:
                    return String(format: "%.f KPH", weatherData.windSpeed.toKPH)
                }
            }
            .eraseToAnyPublisher()
    }

    var imagePublisher: AnyPublisher<UIImage?,Never> {
        weatherDataPublisher
            .map{ UIImage.imageForIcon(with: $0.icon)}
            .eraseToAnyPublisher()
    }
    
}
