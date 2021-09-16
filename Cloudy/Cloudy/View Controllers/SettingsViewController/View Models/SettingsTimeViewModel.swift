//
//  SettingsTimeViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 03/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit

struct SettingsTimeViewModel: SettingsPresentable {

    // MARK: - Properties

    let timeNotation: TimeNotation
    let selection: TimeNotation

    // MARK: - Public API
    
    var text: String {
        switch timeNotation {
        case .twelveHour: return "12 Hour"
        case .twentyFourHour: return "24 Hour"
        }
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        selection == timeNotation ? .checkmark : .none
    }

}
