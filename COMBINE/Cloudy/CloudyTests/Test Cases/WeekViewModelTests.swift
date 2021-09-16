//
//  WeekViewModelTests.swift
//  CloudyTests
//
//  Created by Bart Jacobs on 24/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import XCTest
@testable import Cloudy

class WeekViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    var viewModel: WeekViewModel!
    
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
        viewModel = WeekViewModel(weatherData: weatherData.dailyData)
    }

    override func tearDownWithError() throws {
        
    }
    
    // MARK: - Tests for Number of Sections
    
    func testNumberOfSections() {
        XCTAssertEqual(viewModel.numberOfSections, 1)
    }
    
    // MARK: - Tests for Number of Days

    func testNumberOfDays() {
        XCTAssertEqual(viewModel.numberOfDays, 8)
    }
    
    // MARK: - Tests for View Model for Index

    func testViewModelForIndex() {
        let weatherDayViewModel = viewModel.viewModel(for: 5)

        XCTAssertEqual(weatherDayViewModel.day, "Saturday")
        XCTAssertEqual(weatherDayViewModel.date, "June 27")
    }

}
