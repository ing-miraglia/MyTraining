//
//  LocationsViewController.swift
//  Cloudy
//
//  Created by Bart Jacobs on 10/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationsViewControllerDelegate: AnyObject {
    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation)
}

final class LocationsViewController: UIViewController {

    // MARK: - Types

    private enum Segue {
        static let addLocationView = "SegueAddLocationView"
    }

    // MARK: - Properties

    @IBOutlet private var tableView: UITableView!

    // MARK: -

    var currentLocation: CLLocation?

    // MARK: -
    
    var favorites = UserDefaults.locations

    // MARK: -

    private var hasFavorites: Bool {
        favorites.count > 0
    }

    // MARK: -

    weak var delegate: LocationsViewControllerDelegate?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Title
        title = "Locations"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {
        case Segue.addLocationView:
            if let addLocationViewController = segue.destination as? AddLocationViewController {
                addLocationViewController.delegate = self
                addLocationViewController.viewModel = AddLocationViewModel()
                
            } else {
                fatalError("Unexpected Destination View Controller")
            }
        default: break
        }
    }

    // MARK: - Actions

    @IBAction private func unwindToLocationsViewController(segue: UIStoryboardSegue) {}

}

extension LocationsViewController: UITableViewDataSource {

    private enum Section: Int, CaseIterable {

        // MARK: - Cases
        
        case current
        case favorite

        // MARK: - Properties

        var title: String {
            switch self {
            case .current: return "Current Location"
            case .favorite: return "Favorite Locations"
            }
        }

        var numberOfRows: Int {
            switch self {
            case .current: return 1
            case .favorite: return 0
            }
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("Unexpected Section")
        }

        switch section {
        case .current:
            return 1
        case .favorite:
            return max(favorites.count, 1)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else {
            fatalError("Unexpected Section")
        }
        
        return section.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("Unable to Dequeue Location Table View Cell")
        }

        switch section {
        case .current:
            if let currentLocation = currentLocation {
                cell.configure(with: LocationViewModel(location: currentLocation))
            } else {
                cell.configure(with: "Current Location Unknown")
            }
        case .favorite:
            if favorites.count > 0 {
                // Fetch Favorite
                let favorite = favorites[indexPath.row]

                // Create View Model
                let presentable = LocationViewModel(location: favorite.location, locationAsString: favorite.name)
                
                // Configure Table View Cell
                cell.configure(with: presentable)
            } else {
                // Configure Table View Cell
                cell.configure(with: "No Favorites Found")
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }

        switch section {
        case .current: return false
        case .favorite: return hasFavorites
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Update Favorites
        let location = favorites.remove(at: indexPath.row)

        // Remove Location
        UserDefaults.removeLocation(location)

        // Update Table View
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

}

extension LocationsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }

        var location: CLLocation?

        switch section {
        case .current:
            if let currentLocation = currentLocation {
                location = currentLocation
            }
        case .favorite:
            if hasFavorites {
                location = favorites[indexPath.row].location
            }
        }

        if let newLocation = location {
            // Notify Delegate
            delegate?.controller(self, didSelectLocation: newLocation)

            // Dismiss View Controller
            dismiss(animated: true)
        }
    }

}

extension LocationsViewController: AddLocationViewControllerDelegate {

    func controller(_ controller: AddLocationViewController, didAddLocation location: Location) {
        // Update User Defaults
        UserDefaults.addLocation(location)

        // Update Locations
        favorites.append(location)

        // Update Table View
        tableView.reloadData()
    }

}
