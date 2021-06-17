//
//  SearchCitiesViewModel.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/6.
//

import Foundation


class SearchCitiesViewModel {
    private var delegate: WeatherViewModelDelegate?
    
    init(delegate: WeatherViewModelDelegate) {
        self.delegate = delegate
    }
}

extension SearchCitiesViewModel {
        
    func didSelect(_ item: Coordinate) {
        self.delegate?.didLocationChange(item)
    }
}
