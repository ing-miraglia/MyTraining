//
//  WeatherViewModel.swift
//  Cloudy
//
//  Created by Raffaele Miraglia on 10/09/21.
//  Copyright © 2021 Cocoacasts. All rights reserved.
//
import Combine
import Foundation

class WeatherViewModel {
    //MARK: - Properties
    var loadingPublisher: AnyPublisher<Bool,Never> {
        weatherDataStatePublisher
            .map{$0.isLoading}
            .eraseToAnyPublisher()
    }
    var hasWeatherDataPublisher: AnyPublisher<Bool,Never> {
        weatherDataStatePublisher
            .map{$0.weatherData != nil}
            .eraseToAnyPublisher()
    }
    var hasWeatherDataErrorPublisher: AnyPublisher<Bool,Never> {
        weatherDataStatePublisher
            .map{$0.weatherDataError != nil}
            .eraseToAnyPublisher()
    }

    let weatherDataStatePublisher: AnyPublisher<WeatherDataState,Never>
    
    let timeNotationPublisher: AnyPublisher<TimeNotation,Never>
    let unitNotationPublisher: AnyPublisher<UnitsNotation,Never>
    let temperatureNotationPublisher: AnyPublisher<TemperatureNotation,Never>


    init(weatherDataStatePublisher: AnyPublisher<WeatherDataState,Never>,
         timeNotationPublisher: AnyPublisher<TimeNotation,Never>,
         unitNotationPublisher: AnyPublisher<UnitsNotation,Never>,
         temperatureNotationPublisher: AnyPublisher<TemperatureNotation,Never>) {
        self.weatherDataStatePublisher = weatherDataStatePublisher
        self.timeNotationPublisher = timeNotationPublisher
        self.unitNotationPublisher = unitNotationPublisher
        self.temperatureNotationPublisher = temperatureNotationPublisher
    }
}
