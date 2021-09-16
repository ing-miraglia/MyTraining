//
//  DayViewController.swift
//  Cloudy
//
//  Created by Bart Jacobs on 01/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit
import  Combine

protocol DayViewControllerDelegate: AnyObject {
    func controllerDidTapSettingsButton(controller: DayViewController)
    func controllerDidTapLocationButton(controller: DayViewController)
}

final class DayViewController: WeatherViewController {

    // MARK: - Properties

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var windSpeedLabel: UILabel!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!

    override var weatherViewModel: WeatherViewModel {
        guard let vm = viewModel else {
            fatalError("No view model available")
        }
        return vm
    }
    // MARK: -

    weak var delegate: DayViewControllerDelegate?

    // MARK: -

    var viewModel: DayViewModel?
    
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Public Interface
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupView()
    }

    // MARK: - View Methods
    private func setupBinding() {
        viewModel?.datePublisher
            .assign(to: \.text, on: dateLabel)
            .store(in: &subscriptions)
        
        viewModel?.timePublisher
            .assign(to: \.text, on: timeLabel)
            .store(in: &subscriptions)
        
        viewModel?.temperaturePublisher
            .assign(to: \.text, on: temperatureLabel)
            .store(in: &subscriptions)
        
        viewModel?.summaryPublisher
            .assign(to: \.text, on: descriptionLabel)
            .store(in: &subscriptions)
        
        viewModel?.windSpeedPublisher
            .assign(to: \.text, on: windSpeedLabel)
            .store(in: &subscriptions)
        
        viewModel?.imagePublisher
            .assign(to: \.image, on: iconImageView)
            .store(in: &subscriptions)
        
        viewModel?.loadingPublisher
            .filter{$0}
            .assign(to: \.isHidden, on: weatherDataContainerView)
            .store(in: &subscriptions)
        
        viewModel?.loadingPublisher
            .filter{ $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.weatherDataContainerView.isHidden = true
                self?.messageLabel.isHidden = true
                
            })
            .store(in: &subscriptions)
        

    }
    private func setupView() {
        messageLabel.text = "Cloudy was unable to fetch weather data."
    }

    // MARK: - Actions

    @IBAction private func didTapSettingsButton(_ sender: UIButton) {
        delegate?.controllerDidTapSettingsButton(controller: self)
    }

    @IBAction private func didTapLocationButton(_ sender: UIButton) {
        delegate?.controllerDidTapLocationButton(controller: self)
    }

}
