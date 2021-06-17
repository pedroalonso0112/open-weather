//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/5.
//

import Foundation

protocol WeatherViewModelDelegate: class {
    func didLocationChange(_ coordinate: Coordinate)    
}

class WeatherViewModel {

    let error: Observable<String?> = Observable(nil)
    let loading: Observable<Bool> = Observable(false)
    
    let weather: Observable<WeatherInfo?> = Observable(nil)
    let city: Observable<City?> = Observable(nil)
    
    let weatherData: Observable<FiveDayWeather?> = Observable(nil)
    
    let times: Observable<[Int]> = Observable([])
    
    var delegate: WeatherViewModelDelegate?
        
    var selectedDay: Int = 0 {
        didSet {
            self.refreshTimes()
        }
    }
    
    var selectedTime: Int = 0 {
        didSet {
            selectWeather()
        }
    }
    
    
    func load(latitude: Double, longitude: Double) {
        // Loading -> true
        self.loading.value = true
                
        WeatherAPI.instance.weatherDataAt(latitude: latitude, longitude: longitude, callback:  { result in
            switch result {
            case .success(let data):
                self.loading.value = false
                
                guard let weatherData = try? JSONDecoder().decode(FiveDayWeather.self, from: data) else {
                    self.error.value = "Parse Error"
                    return
                }
                self.weatherData.value = weatherData
                
                self.city.value = weatherData.city
                
                self.refreshTimes()
                
                self.selectWeather()
                
                break
            case .failure(let error):
                self.error.value = error
                break
            }
        })
    }
    
    // MARK: - Create Time Table
    
    func refreshTimes() {
        
        guard let weathers = weatherData.value?.list.filter( { $0.dtTxt.contains(Date.addedDay(selectedDay)) }) else {
            return
        }
        
        var data = [Int]()
        
        for weather in weathers {
            data.append(weather.dt)
        }
        times.value = data
        
        selectedTime = 0
    }
    
    // MARK: - Select Weather
    
    private func selectWeather() {
        if times.value.count == 0 {
            return
        }
        
        guard let weather = weatherData.value?.list.first(where: { $0.dt == times.value[selectedTime] }) else {
            return
        }
        
        self.weather.value = weather
    }
}

extension WeatherViewModel: WeatherViewModelDelegate {
    func didLocationChange(_ coordinate: Coordinate) {
        self.load(latitude: coordinate.lat, longitude: coordinate.lon)
    }
    
}
