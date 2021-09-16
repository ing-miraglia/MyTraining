//
//  WeekViewController.swift
//  Cloudy
//
//  Created by Bart Jacobs on 01/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit
import Combine

final class WeekViewController: WeatherViewController {

    // MARK: - Properties

    @IBOutlet private var tableView: UITableView! {
        didSet {
            // Configure Table View
            tableView.separatorInset = UIEdgeInsets.zero
        }
    }

    override var weatherViewModel: WeatherViewModel {
        guard let vm = viewModel else {
            fatalError("No view model available")
        }
        return vm
    }
    
    // MARK: -

    var viewModel: WeekViewModel?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Binding
        setupBinding()
        
        // Setup View
        setupView()
        viewModel?.start()

    }

    
    // MARK: - View Methods

    private func setupView() {
        messageLabel.text = "Cloudy was unable to fetch weather data."
    }
    
    // MARK: -
    private func updateWeatherDataContainerView() {
        // Show Weather Data Container View
        weatherDataContainerView.isHidden = false

        // Update Table View
        tableView.reloadData()
    }
    
    // MARK: - Helper Methods
    private func setupBinding(){
        viewModel?.bind(to: tableView)
    }
    
}
