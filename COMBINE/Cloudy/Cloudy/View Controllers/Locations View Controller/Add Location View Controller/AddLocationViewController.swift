//
//  AddLocationViewController.swift
//  Cloudy
//
//  Created by Bart Jacobs on 10/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit

protocol AddLocationViewControllerDelegate: AnyObject {
    func controller(_ controller: AddLocationViewController, didAddLocation location: Location)
}

final class AddLocationViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: -
    
    var viewModel: AddLocationViewModel?

    // MARK: -

    weak var delegate: AddLocationViewControllerDelegate?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Title
        title = "Add Location"

        // Install Handlers
        viewModel?.locationsDidChange = { [weak self] (locations) in
            self?.tableView.reloadData()
        }

        viewModel?.queryingDidChange = { [weak self] (querying) in
            if querying {
                self?.activityIndicatorView.startAnimating()
            } else {
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Show Keyboard
        searchBar.becomeFirstResponder()
    }

}

extension AddLocationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfLocations ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("Unable to Dequeue Location Table View Cell")
        }

        guard let presentable = viewModel?.presentableForLocation(at: indexPath.row) else {
            fatalError("No View Model Available")
        }
        
        // Configure Table View Cell
        cell.configure(with: presentable)

        return cell
    }

}

extension AddLocationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = viewModel?.location(at: indexPath.row) else {
            return
        }

        // Notify Delegate
        delegate?.controller(self, didAddLocation: location)

        // Pop View Controller From Navigation Stack
        navigationController?.popViewController(animated: true)
    }

}

extension AddLocationViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        searchBar.resignFirstResponder()

        // Update Query
        viewModel?.query = searchBar.text ?? ""
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        searchBar.resignFirstResponder()
        
        // Reset Query
        viewModel?.query = ""
    }

}
