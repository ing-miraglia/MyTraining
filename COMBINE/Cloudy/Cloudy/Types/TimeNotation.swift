//
//  TimeNotation.swift
//  Cloudy
//
//  Created by Bart Jacobs on 15/05/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

enum TimeNotation: Int {
    
    // MARK: - Cases
    
    case twelveHour
    case twentyFourHour
    
    // MARK: - Properties
    
    var dateFormat: String {
        switch self {
        case .twelveHour: return "hh:mm a"
        case .twentyFourHour: return "HH:mm"
        }
    }
    
}
