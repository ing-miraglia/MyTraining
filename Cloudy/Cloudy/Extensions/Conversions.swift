//
//  Conversions.swift
//  Cloudy
//
//  Created by Bart Jacobs on 03/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import Foundation

extension Double {

    var toCelcius: Double {
        (self - 32.0) / 1.8
    }

    var toKPH: Double {
        self * 1.609344
    }

}
