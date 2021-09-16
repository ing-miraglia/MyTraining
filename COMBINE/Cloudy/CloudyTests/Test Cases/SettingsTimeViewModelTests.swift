//
//  SettingsTimeViewModelTests.swift
//  CloudyTests
//
//  Created by Bart Jacobs on 12/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import XCTest
@testable import Cloudy

class SettingsTimeViewModelTests: XCTestCase {

    // MARK: - Set Up & Tear Down
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Reset User Defaults
        UserDefaults.standard.removeObject(forKey: "timeNotation")
    }

    // MARK: - Tests for Text

    func testText_TwelveHour() {
        let viewModel = SettingsTimeViewModel(timeNotation: .twelveHour)

        XCTAssertEqual(viewModel.text, "12 Hour")
    }
    
    func testText_TwentyFourHour() {
        let viewModel = SettingsTimeViewModel(timeNotation: .twentyFourHour)

        XCTAssertEqual(viewModel.text, "24 Hour")
    }
    
    // MARK: - Tests for Accessory Type
    
    func testAccessoryType_TwelveHour_TwelveHour() {
        let timeNotation: TimeNotation = .twelveHour
        UserDefaults.standard.set(timeNotation.rawValue, forKey: "timeNotation")

        let viewModel = SettingsTimeViewModel(timeNotation: .twelveHour)
        
        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.checkmark)
    }
    
    func testAccessoryType_TwelveHour_TwentyFourHour() {
        let timeNotation: TimeNotation = .twelveHour
        UserDefaults.standard.set(timeNotation.rawValue, forKey: "timeNotation")

        let viewModel = SettingsTimeViewModel(timeNotation: .twentyFourHour)
        
        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.none)
    }
    
    func testAccessoryType_TwentyFourHour_TwelveHour() {
        let timeNotation: TimeNotation = .twentyFourHour
        UserDefaults.standard.set(timeNotation.rawValue, forKey: "timeNotation")

        let viewModel = SettingsTimeViewModel(timeNotation: .twelveHour)
        
        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.none)
    }
    
    func testAccessoryType_TwentyFourHour_TwentyFourHour() {
        let timeNotation: TimeNotation = .twentyFourHour
        UserDefaults.standard.set(timeNotation.rawValue, forKey: "timeNotation")

        let viewModel = SettingsTimeViewModel(timeNotation: .twentyFourHour)
        
        XCTAssertEqual(viewModel.accessoryType, UITableViewCell.AccessoryType.checkmark)
    }

}
