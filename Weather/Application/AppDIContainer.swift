//
//  DIConfiguration.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/6.
//

import Foundation

final class AppDIContainer {
    
    static let instance = AppDIContainer()
    
    // MARK: - Weather
    func makeWeatherViewController() -> WeatherViewController {
        return WeatherViewController.create(with: makeWeatherViewModel())
    }
    
    func makeWeatherViewModel() -> WeatherViewModel {
        return WeatherViewModel()
    }
    
    // MARK: - Search
    func makeSearchCitiesViewController(delegate: WeatherViewModelDelegate) -> SearchCitiesViewController {
        return SearchCitiesViewController.create(with: makeSearchCitiesViewModel(delegate: delegate))
    }
    
    func makeSearchCitiesViewModel(delegate: WeatherViewModelDelegate) -> SearchCitiesViewModel {
        return SearchCitiesViewModel(delegate: delegate)
    }
}
