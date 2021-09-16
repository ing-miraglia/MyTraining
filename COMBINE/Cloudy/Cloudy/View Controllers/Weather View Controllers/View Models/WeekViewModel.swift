//
//  WeekViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 27/05/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit
import  Combine

final class WeekViewModel: WeatherViewModel {

    // MARK: - Properties
    private var dataSource: UITableViewDiffableDataSource<Int,WeatherDayViewModel>?
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Public API
    func start(){
        let weatherDailyDataPublisher = weatherDataStatePublisher
            .compactMap { $0.weatherData?.dailyData }
        
        weatherDailyDataPublisher.combineLatest(unitNotationPublisher,temperatureNotationPublisher)
            .map{ dailyData, unitNotation, tempratureNotation -> [WeatherDayViewModel] in
                dailyData.map{WeatherDayViewModel(weatherDayData: $0, unitNotation: unitNotation, temperatureNotation: tempratureNotation)}
            }
            .sink { [weak self] weatherData in
                var snapshot = NSDiffableDataSourceSnapshot<Int,WeatherDayViewModel>()
                snapshot.appendSections([0])
                snapshot.appendItems(weatherData)
                
                self?.dataSource?.apply(snapshot,animatingDifferences: false)
            }.store(in: &subscriptions)
    }
    func bind(to tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, presentable -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDayTableViewCell.reuseIdentifier) as? WeatherDayTableViewCell else {
                fatalError("Unable to dequeue WeatherDayTableViewCell")
            }
            cell.configure(with: presentable)
            return cell
        })
    }
}
