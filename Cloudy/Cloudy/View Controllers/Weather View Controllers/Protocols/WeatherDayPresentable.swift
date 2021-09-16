//
//  WeatherDayPresentable.swift
//  Cloudy
//
//  Created by Bart Jacobs on 09/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit

protocol WeatherDayPresentable {
    
    // MARK: - Properties
    
    var day: String { get }
    var date: String { get }
    var image: UIImage? { get }
    var windSpeed: String { get }
    var temperature: String { get }
    
}
