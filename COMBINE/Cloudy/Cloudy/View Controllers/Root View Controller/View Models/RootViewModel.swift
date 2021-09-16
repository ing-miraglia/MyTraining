//
//  RootViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 21/09/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

final class RootViewModel: NSObject {
    
    // MARK: - public Properties
    @Published private(set) var currentLocation: CLLocation?
    
    var weatherDataStatePublisher: AnyPublisher<WeatherDataState,Never> {
        weatherDataStateSubject
            .eraseToAnyPublisher()
    }
    
    // MARK: - private Properties

    private var currentLocationPublisher: AnyPublisher<CLLocation,Never> {
        Publishers.Zip($currentLocation, $currentLocation.dropFirst())
            .compactMap { previousLocation, currentLocation -> CLLocation? in
                guard let previous = previousLocation, let current = currentLocation else {
                    return currentLocation
                }
                let distance = previous.distance(from: current)
                return distance > 10000 ? current : nil
                
            }.eraseToAnyPublisher()
    }
    
    private let weatherDataStateSubject = PassthroughSubject<WeatherDataState,Never>()
    
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: -
    
    private lazy var locationManager: CLLocationManager = {
        // Initialize Location Manager
        let locationManager = CLLocationManager()

        // Configure Location Manager
        locationManager.distanceFilter = 1000.0
        locationManager.desiredAccuracy = 1000.0

        return locationManager
    }()

    private var weatherDataTask: URLSessionDataTask?

    // MARK: - Public API

    func start(){
        setupBindings()
        // Setup Notification Handling
        setupNotificationHandling()
        weatherDataStateSubject.send(.loading)
    }

    // MARK: - Helper Methods
    
    private func fetchWeatherData(for location: CLLocation) {
        // Cancel In Progress Data Task
        weatherDataTask?.cancel()

        // Helpers
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Create URL
        let request = WeatherServiceRequest(latitude: latitude, longitude: longitude)
        
        URLSession.shared.dataTaskPublisher(for: request.url)
            .retry(3)
            .catch({ _ in
                URLSession.shared.dataTaskPublisher(for: request.falbackUrl)
            })
            .tryMap({ data, response  -> WeatherData in
                guard
                    let response = response as? HTTPURLResponse,
                    (200 ..< 300).contains(response.statusCode) else {
                    throw WeatherDataError.failedRequest
                }
                
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Configure JSON Decoder
                decoder.dateDecodingStrategy = .secondsSince1970
                
                guard let weatherData = try? decoder.decode(WeatherData.self, from: data) else {
                    throw WeatherDataError.invalidResponse
                }
                return weatherData
            })
            .mapError({ error -> WeatherDataError in
                error as? WeatherDataError ?? .failedRequest
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                debugPrint("COMPLETE",completion)
                switch completion {
                case .finished : break
                case .failure(let error) :
                    self?.weatherDataStateSubject.send(.error(error))
                }
            } receiveValue: { [weak self] weatherDAta in
                self?.weatherDataStateSubject.send(.data(weatherDAta))
            }.store(in: &subscriptions)

    }
    
    private func setupBindings() {
        let weatherDataPublisher = weatherDataStateSubject
            .map{ $0.weatherData}
        
        currentLocationPublisher.combineLatest(weatherDataPublisher)
            .removeDuplicates(by: { prev, next in
                prev.0 == next.0
            })
            .compactMap { (location, weatherData) -> CLLocation? in
                guard let weatherData = weatherData else {
                    return location
                }
                return Date().timeIntervalSince(weatherData.time) > 3_600 ? location : nil
            }.sink { [weak self] location in
                self?.fetchWeatherData(for: location)
            }.store(in: &subscriptions)
    }
    
    private func setupNotificationHandling() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification).throttle(for: .seconds(10), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] _ in
                self?.requestLocation()
        }.store(in: &subscriptions)
    }
    
    // MARK: -

    private func requestLocation() {
        // Configure Location Manager
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            // Request Authorization
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension RootViewModel: CLLocationManagerDelegate {

    // MARK: - Authorization

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse:
            manager.requestLocation()
        default:
            // Fall Back to Default Location
            currentLocation = CLLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude)
        }
    }

    // MARK: - Location Updates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Update Current Location
            currentLocation = location

            // Reset Delegate
            manager.delegate = nil

            // Stop Location Manager
            manager.stopUpdatingLocation()

        } else {
            // Fall Back to Default Location
            currentLocation = CLLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if currentLocation == nil {
            // Fall Back to Default Location
            currentLocation = CLLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude)
        }
    }

}

extension RootViewModel: LocationsViewControllerDelegate {

    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation) {
        currentLocation = location
    }

}
