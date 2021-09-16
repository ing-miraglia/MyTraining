//
//  UIImage.swift
//  Cloudy
//
//  Created by Bart Jacobs on 21/05/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit

extension UIImage {

    class func imageForIcon(with name: String) -> UIImage? {
        switch name {
        case "clear-day", "clear-night", "rain", "snow", "sleet": return UIImage(named: name)
        case "wind", "cloudy", "partly-cloudy-day", "partly-cloudy-night": return UIImage(named: "cloudy")
        default: return UIImage(named: "clear-day")
        }
    }

}
