//
//  RootViewController.swift
//  Cloudy
//
//  Created by Bart Jacobs on 01/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit
import Combine
final class RootViewController: UIViewController {

    // MARK: - Types
    
    private enum AlertType {
        
        case notAuthorizedToRequestLocation
        case failedToRequestLocation
        case noWeatherDataAvailable

    }
    
    // MARK: -

    private enum Segue {
        static let dayView = "SegueDayView"
        static let weekView = "SegueWeekView"
        static let settingsView = "SegueSettingsView"
        static let locationsView = "SegueLocationsView"
    }

    // MARK: - Properties

    @IBOutlet private var dayViewController: DayViewController!
    @IBOutlet private var weekViewController: WeekViewController!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    var viewModel: RootViewModel?
    
    private let settingsViewModel = SettingsViewModel()
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindigs()
        viewModel?.start()
    }
    private func setupBindigs() {
        viewModel?.weatherDataStatePublisher
            .compactMap { $0.weatherDataError }
            .sink(receiveValue: { [weak self] error in
                switch error {
                case .notAuthorizedToRequestLocation:
                    self?.presentAlert(of: .notAuthorizedToRequestLocation)
                case .failedToRequestLocation:
                    self?.presentAlert(of: .failedToRequestLocation)
                case .failedRequest,
                     .invalidResponse:
                    self?.presentAlert(of: .noWeatherDataAvailable)
                }
        }).store(in: &subscriptions)

    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewModel = viewModel, let identifier = segue.identifier else {
            return
        }

        switch identifier {
        case Segue.dayView:
            guard let destination = segue.destination as? DayViewController else {
                fatalError("Unexpected Destination View Controller")
            }

            // Configure Destination
            destination.delegate = self

            // Update Day View Controller
            self.dayViewController = destination
            self.dayViewController.viewModel = DayViewModel(weatherDataStatePublisher: viewModel.weatherDataStatePublisher,timeNotationPublisher: settingsViewModel.timeNotationPublisher,unitNotationPublisher: settingsViewModel.unitsNotationPublisher,temperatureNotationPublisher: settingsViewModel.temperatureNotationPublisher)
        case Segue.weekView:
            guard let destination = segue.destination as? WeekViewController else {
                fatalError("Unexpected Destination View Controller")
            }

            // Update Week View Controller
            self.weekViewController = destination
            self.weekViewController.viewModel = WeekViewModel(weatherDataStatePublisher: viewModel.weatherDataStatePublisher,timeNotationPublisher: settingsViewModel.timeNotationPublisher,unitNotationPublisher: settingsViewModel.unitsNotationPublisher,temperatureNotationPublisher: settingsViewModel.temperatureNotationPublisher)

        case Segue.locationsView:
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected Destination View Controller")
            }

            guard let destination = navigationController.topViewController as? LocationsViewController else {
                fatalError("Unexpected Destination View Controller")
            }
            
            // Configure Destination
            destination.delegate = viewModel
            destination.currentLocation = viewModel.currentLocation
        default:
            break
        }
    }

    // MARK: - Segue Actions
    @IBSegueAction private func showSettings(coder: NSCoder) -> SettingsViewController? {
        SettingsViewController(coder: coder, viewModel: settingsViewModel)
    }
    @IBAction private func unwindToRootViewController(segue: UIStoryboardSegue) {}

    // MARK: - Helper Methods
    
    private func presentAlert(of alertType: AlertType) {
        // Helpers
        let title: String
        let message: String
        
        switch alertType {
        case .notAuthorizedToRequestLocation:
            title = "Unable to Fetch Weather Data for Your Location"
            message = "Cloudy is not authorized to access your current location. You can grant Cloudy access to your current location in the Settings application."
        case .failedToRequestLocation:
            title = "Unable to Fetch Weather Data for Your Location"
            message = "Cloudy is not able to fetch your current location due to a technical issue."
        case .noWeatherDataAvailable:
            title = "Unable to Fetch Weather Data"
            message = "Cloudy is unable to fetch weather data. Please make sure your device is connected over Wi-Fi or cellular."
        }
        
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add Cancel Action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present Alert Controller
        present(alertController, animated: true)
    }

}

extension RootViewController: DayViewControllerDelegate {

    func controllerDidTapSettingsButton(controller: DayViewController) {
        performSegue(withIdentifier: Segue.settingsView, sender: self)
    }

    func controllerDidTapLocationButton(controller: DayViewController) {
        performSegue(withIdentifier: Segue.locationsView, sender: self)
    }

}
