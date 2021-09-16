//
//  WeatherViewController.swift
//  Cloudy
//
//  Created by Bart Jacobs on 01/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit
import Combine
class WeatherViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private(set) var messageLabel: UILabel!
    @IBOutlet private(set) var weatherDataContainerView: UIView!
    @IBOutlet private(set) var activityIndicatorView: UIActivityIndicatorView!
    
    var weatherViewModel: WeatherViewModel {
        fatalError("Subclass are required to override `weatherViewModel`.")
    }
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View
        setupView()
        bind(to: weatherViewModel)
    }

    // MARK: - View Methods

    private func setupView() {
        // Configure Message Label
        messageLabel.isHidden = true

        // Configure Weather Data Container View
        weatherDataContainerView.isHidden = true

        // Configure Activity Indicator View
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }
    
    private func bind(to viewModel: WeatherViewModel){
        viewModel.loadingPublisher
            .map{!$0}
            .assign(to: \.isHidden, on: activityIndicatorView)
            .store(in: &subscriptions)
        
        viewModel.hasWeatherDataPublisher
            .map{!$0}
            .assign(to: \.isHidden, on: weatherDataContainerView)
            .store(in: &subscriptions)
        
        viewModel.hasWeatherDataErrorPublisher
            .map{!$0}
            .assign(to: \.isHidden, on: messageLabel)
            .store(in: &subscriptions)
    }
    
}
