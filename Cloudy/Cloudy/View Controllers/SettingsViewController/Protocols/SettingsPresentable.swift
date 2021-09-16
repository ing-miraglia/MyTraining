//
//  SettingsPresentable.swift
//  Cloudy
//
//  Created by Bart Jacobs on 05/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit

protocol SettingsPresentable {

    // MARK: - Properties
    
    var text: String { get }
    
    // MARK: -
    
    var accessoryType: UITableViewCell.AccessoryType { get }

}
