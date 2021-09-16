//
//  SettingsTemperatureViewModelTests.swift
//  CloudyTests
//
//  Created by Bart Jacobs on 12/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import XCTest
@testable import Cloudy

class SettingsTemperatureViewModelTests: XCTestCase {

    // MARK: - Set Up & Tear Down

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()

        // Reset User Defaults
        UserDefaults.standard.removeObject(forKey: "temperatureNotation")
    }

    // MARK: - Tests for Text

    func testText_Fahrenheit() {
        let viewModel = SettingsTemperatureViewModel(temperatureNotation: .fahrenheit)

        XCTAssertEqual(viewModel.text, "Fahrenheit")
    }

    func testText_Celsius() {
        let viewModel = SettingsTemperatureViewModel(temperatureNotation: .celsius)

        XCTAssertEqual(viewModel.text, "Celsius")
    }

    // MARK: - Tests for Accessory Type

    func testAccessoryType_Fahrenheit_Fahrenheit() {
        let temperatureNotation: TemperatureNotation = .fahrenheit
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: "temperatureNotation")

        let viewModel = SettingsTemperatureViewModel(temperatureNotation: .fahrenheit)

        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.checkmark)
    }

    func testAccessoryType_Fahrenheit_Celsius() {
        let temperatureNotation: TemperatureNotation = .fahrenheit
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: "temperatureNotation")

        let viewModel = SettingsTemperatureViewModel(temperatureNotation: .celsius)

        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.none)
    }

    func testAccessoryType_Celsius_Fahrenheit() {
        let temperatureNotation: TemperatureNotation = .celsius
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: "temperatureNotation")

        let viewModel = SettingsTemperatureViewModel(temperatureNotation: .fahrenheit)

        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.none)
    }

    func testAccessoryType_Celsius_Celsius() {
        let temperatureNotation: TemperatureNotation = .celsius
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: "temperatureNotation")

        let viewModel = SettingsTemperatureViewModel(temperatureNotation: .celsius)

        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.checkmark)
    }

}
