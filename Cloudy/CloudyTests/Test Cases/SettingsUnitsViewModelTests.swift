//
//  SettingsUnitsViewModelTests.swift
//  CloudyTests
//
//  Created by Bart Jacobs on 12/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import XCTest
@testable import Cloudy

class SettingsUnitsViewModelTests: XCTestCase {

    // MARK: - Set Up & Tear Down

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()

        // Reset User Defaults
        UserDefaults.standard.removeObject(forKey: "unitsNotation")
    }

    // MARK: - Tests for Text

    func testText_Imperial() {
        let viewModel = SettingsUnitsViewModel(unitsNotation: .imperial)

        XCTAssertEqual(viewModel.text, "Imperial")
    }

    func testText_Metric() {
        let viewModel = SettingsUnitsViewModel(unitsNotation: .metric)

        XCTAssertEqual(viewModel.text, "Metric")
    }

    // MARK: - Tests for Accessory Type

    func testAccessoryType_Imperial_Imperial() {
        let unitsNotation: UnitsNotation = .imperial
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: "unitsNotation")

        let viewModel = SettingsUnitsViewModel(unitsNotation: .imperial)

        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.checkmark)
    }


    func testAccessoryType_Imperial_Metric() {
        let unitsNotation: UnitsNotation = .imperial
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: "unitsNotation")

        let viewModel = SettingsUnitsViewModel(unitsNotation: .metric)

        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.none)
    }

    func testAccessoryType_Metric_Imperial() {
        let unitsNotation: UnitsNotation = .metric
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: "unitsNotation")

        let viewModel = SettingsUnitsViewModel(unitsNotation: .imperial)

        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.none)
    }


    func testAccessoryType_Metric_Metric() {
        let unitsNotation: UnitsNotation = .metric
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: "unitsNotation")

        let viewModel = SettingsUnitsViewModel(unitsNotation: .metric)

        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.checkmark)
    }

}
