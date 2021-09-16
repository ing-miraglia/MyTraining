//
//  SettingsTemperatureViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 03/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit

struct SettingsTemperatureViewModel: SettingsPresentable {

    // MARK: - Properties

    let temperatureNotation: TemperatureNotation
    let selection: TemperatureNotation
    // MARK: - Public Interface

    var text: String {
        switch temperatureNotation {
        case .fahrenheit: return "Fahrenheit"
        case .celsius: return "Celsius"
        }
    }

    var accessoryType: UITableViewCell.AccessoryType {
        selection == temperatureNotation ? .checkmark : .none
    }
    
}
