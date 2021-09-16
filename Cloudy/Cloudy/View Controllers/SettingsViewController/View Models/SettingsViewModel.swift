//
//  SettingsViewModel.swift
//  Cloudy
//
//  Created by Raffaele Miraglia on 10/09/21.
//  Copyright © 2021 Cocoacasts. All rights reserved.
//
import Combine
import Foundation

final class SettingsViewModel {
    var timeNotationPublisher: AnyPublisher<TimeNotation,Never> {
        $timeNotation.eraseToAnyPublisher()
    }
    @Published var timeNotation = UserDefaults.timeNotation
    
    //MARK: -
    var unitsNotationPublisher: AnyPublisher<UnitsNotation,Never> {
        $unitsNotation.eraseToAnyPublisher()
    }
    @Published var unitsNotation = UserDefaults.unitsNotation
    
    //MARK: -
    var temperatureNotationPublisher: AnyPublisher<TemperatureNotation,Never> {
        $temperatureNotation.eraseToAnyPublisher()
    }
    @Published var temperatureNotation = UserDefaults.temperatureNotation
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        setupBindings()
    }
    
    //MARK: - Helpers
    private func setupBindings(){
        $timeNotation.sink {
            UserDefaults.timeNotation = $0
        }.store(in: &subscriptions)
        
        $unitsNotation.sink {
            UserDefaults.unitsNotation = $0
        }.store(in: &subscriptions)
        
        $temperatureNotation.sink {
            UserDefaults.temperatureNotation = $0
        }.store(in: &subscriptions)
    }
}

fileprivate extension UserDefaults {
    private enum Keys {
        static let timeNotation = "timeNotation"
        static let unitsNotation = "unitsNotation"
        static let temperatureNotation = "temperatureNotation"
    }
    
// MARK: - Time Notation

    class var timeNotation: TimeNotation {
        get {
            let storedValue = UserDefaults.standard.integer(forKey: Keys.timeNotation)
            return TimeNotation(rawValue: storedValue) ?? TimeNotation.twelveHour
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.timeNotation)
        }
    }
    
    // MARK: - Units Notation
    
    class var unitsNotation: UnitsNotation {
        get {
            let storedValue = UserDefaults.standard.integer(forKey: Keys.unitsNotation)
            return UnitsNotation(rawValue: storedValue) ?? UnitsNotation.imperial
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.unitsNotation)
        }
    }
    
    // MARK: - Temperature Notation
    
    class var temperatureNotation: TemperatureNotation {
        get {
            let storedValue = UserDefaults.standard.integer(forKey: Keys.temperatureNotation)
            return TemperatureNotation(rawValue: storedValue) ?? TemperatureNotation.fahrenheit
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.temperatureNotation)
        }
    }
    
}

