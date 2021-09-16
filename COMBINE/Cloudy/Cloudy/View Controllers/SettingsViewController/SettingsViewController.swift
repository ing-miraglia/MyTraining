//
//  SettingsViewController.swift
//  Cloudy
//
//  Created by Bart Jacobs on 03/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit
import Combine

final class SettingsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private var tableView: UITableView! {
        didSet {
            // Configure Table View
            tableView.separatorInset = UIEdgeInsets.zero
        }
    }

    // MARK: -
    private let viewModel: SettingsViewModel
    
    // MARK: - Initialization
    init?(coder: NSCoder, viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Title
        title = "Settings"
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    private enum Section: Int, CaseIterable {
        
        // MARK: - Cases
        
        case time
        case units
        case temperature

        // MARK: - Properties
        
        var numberOfRows: Int {
            2
        }

    }

    // MARK: - Table View Data Source Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("Unexpected Section")
        }
        
        return section.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError("Unable to Dequeue Settings Table View Cell")
        }

        // Configure Cell
        cell.bind(to: settingsPresentablePublisher(for: indexPath))
        
        return cell
    }

    // MARK: - Table View Delegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }

        switch section {
        case .time:
            if let newTimeNotation = TimeNotation(rawValue: indexPath.row) {
                viewModel.timeNotation = newTimeNotation
            }
        case .units:
            if let newUnitsNotation = UnitsNotation(rawValue: indexPath.row) {
                viewModel.unitsNotation = newUnitsNotation
            }
        case .temperature:
            if let newTemperatureNotation = TemperatureNotation(rawValue: indexPath.row) {
                viewModel.temperatureNotation = newTemperatureNotation
            }
        }
    }

    // MARK: - Helper Methods

    private func settingsPresentablePublisher(for indexPath: IndexPath) -> AnyPublisher<SettingsPresentable,Never> {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }
        
        switch section {
        case .time:
           return viewModel.timeNotationPublisher
                .compactMap { selection -> SettingsPresentable? in
                    guard let timeNotation = TimeNotation(rawValue: indexPath.row) else {
                        return nil
                    }
                    return SettingsTimeViewModel(timeNotation: timeNotation, selection: selection)

                }.eraseToAnyPublisher()
            
        case .units:
            return viewModel.unitsNotationPublisher
                .compactMap { selection -> SettingsPresentable? in
                    guard let unitNotation = UnitsNotation(rawValue: indexPath.row) else {
                        return nil
                    }
                    return SettingsUnitsViewModel(unitsNotation: unitNotation, selection: selection)

                }.eraseToAnyPublisher()
        case .temperature:
            return viewModel.temperatureNotationPublisher
                .compactMap { selection -> SettingsPresentable? in
                    guard let temperatureNotation = TemperatureNotation(rawValue: indexPath.row) else {
                        return nil
                    }
                    return SettingsTemperatureViewModel(temperatureNotation: temperatureNotation, selection: selection)

                }.eraseToAnyPublisher()
        }
    }
    
}
