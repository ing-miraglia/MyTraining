//
//  DayViewModelTests.swift
//  CloudyTests
//
//  Created by Bart Jacobs on 22/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit
import XCTest
@testable import Cloudy

class DayViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    var viewModel: DayViewModel!
    
    // MARK: - Set Up & Tear Down
    
    override func setUpWithError() throws {
        // Load Stub
        let data = loadStub(name: "weather", extension: "json")
        
        // Create JSON Decoder
        let decoder = JSONDecoder()
        
        // Configure JSON Decoder
        decoder.dateDecodingStrategy = .secondsSince1970
        
        // Decode JSON
        let weatherData = try decoder.decode(WeatherData.self, from: data)
        
        // Initialize View Model
        viewModel = DayViewModel(weatherData: weatherData)
    }

    override func tearDownWithError() throws {
        // Reset User Defaults
        UserDefaults.standard.removeObject(forKey: "timeNotation")
        UserDefaults.standard.removeObject(forKey: "unitsNotation")
        UserDefaults.standard.removeObject(forKey: "temperatureNotation")
    }
    
    // MARK: - Tests for Date

    func testDate() {
        XCTAssertEqual(viewModel.date, "Mon, June 22")
    }

    // MARK: - Tests for Time

    func testTime_TwelveHour() {
        let timeNotation: TimeNotation = .twelveHour
        UserDefaults.standard.set(timeNotation.rawValue, forKey: "timeNotation")
        
        XCTAssertEqual(viewModel.time, "04:53 PM")
    }
    
    func testTime_TwentyFourHour() {
        let timeNotation: TimeNotation = .twentyFourHour
        UserDefaults.standard.set(timeNotation.rawValue, forKey: "timeNotation")
        
        XCTAssertEqual(viewModel.time, "16:53")
    }
    
    // MARK: - Tests for Summary

    func testSummary() {
        XCTAssertEqual(viewModel.summary, "Overcast")
    }

    // MARK: - Tests for Temperature

    func testTemperature_Fahrenheit() {
        let temperatureNotation: TemperatureNotation = .fahrenheit
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: "temperatureNotation")

        XCTAssertEqual(viewModel.temperature, "68.7 °F")
    }

    func testTemperature_Celsius() {
        let temperatureNotation: TemperatureNotation = .celsius
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: "temperatureNotation")

        XCTAssertEqual(viewModel.temperature, "20.4 °C")
    }

    // MARK: - Tests for Wind Speed

    func testWindSpeed_Imperial() {
        let unitsNotation: UnitsNotation = .imperial
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: "unitsNotation")

        XCTAssertEqual(viewModel.windSpeed, "6 MPH")
    }

    func testWindSpeed_Metric() {
        let unitsNotation: UnitsNotation = .metric
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: "unitsNotation")

        print(viewModel.windSpeed)

        XCTAssertEqual(viewModel.windSpeed, "10 KPH")
    }

    // MARK: - Tests for Image

    func testImage() {
        let viewModelImage = viewModel.image
        let imageDataViewModel = viewModelImage!.pngData()!
        let imageDataReference = UIImage(named: "cloudy")!.pngData()!

        XCTAssertNotNil(viewModelImage)
        XCTAssertEqual(viewModelImage!.size.width, 236.0)
        XCTAssertEqual(viewModelImage!.size.height, 172.0)
        XCTAssertEqual(imageDataViewModel, imageDataReference)
    }
    
}
