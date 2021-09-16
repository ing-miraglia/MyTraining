//
//  WeatherDayViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 09/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit

struct WeatherDayViewModel: WeatherDayPresentable, Hashable {

    // MARK: - Properties

    let weatherDayData: WeatherDayData

    // MARK: -

    private let dateFormatter = DateFormatter()
    let unitNotation: UnitsNotation
    let temperatureNotation: TemperatureNotation

    // MARK: -

    var day: String {
        // Configure Date Formatter
        dateFormatter.dateFormat = "EEEE"

        return dateFormatter.string(from: weatherDayData.time)
    }

    var date: String {
        // Configure Date Formatter
        dateFormatter.dateFormat = "MMMM d"

        return dateFormatter.string(from: weatherDayData.time)
    }

    var temperature: String {
        let min = format(temperature: weatherDayData.temperatureMin)
        let max = format(temperature: weatherDayData.temperatureMax)

        return "\(min) - \(max)"
    }

    var windSpeed: String {
        let windSpeed = weatherDayData.windSpeed

        switch unitNotation {
        case .imperial:
            return String(format: "%.f MPH", windSpeed)
        case .metric:
            return String(format: "%.f KPH", windSpeed.toKPH)
        }
    }

    var image: UIImage? {
        UIImage.imageForIcon(with: weatherDayData.icon)
    }

    // MARK: - Helper Methods

    private func format(temperature: Double) -> String {
        switch temperatureNotation {
        case .fahrenheit:
            return String(format: "%.0f °F", temperature)
        case .celsius:
            return String(format: "%.0f °C", temperature.toCelcius)
        }
    }

}
