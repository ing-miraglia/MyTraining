//
//  SettingsUnitsViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 03/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit

struct SettingsUnitsViewModel: SettingsPresentable {

    // MARK: - Properties

    let unitsNotation: UnitsNotation
    let selection: UnitsNotation
    // MARK: - Public API

    var text: String {
        switch unitsNotation {
        case .imperial: return "Imperial"
        case .metric: return "Metric"
        }
    }

    var accessoryType: UITableViewCell.AccessoryType {
        selection == unitsNotation ? .checkmark : .none
    }
    
}
