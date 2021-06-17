//
//  FiveDayWeather.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/5.
//

import Foundation

// MARK: FiveDayWeather
struct FiveDayWeather: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [WeatherInfo]
    let city: City
}

// MARK: City
struct City: Codable {
    let id: Int
    let name: String
    let country: String
    let timezone: Int
    var population: Int?
}

// MARK: List
struct WeatherInfo: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let sys: Sys
    let dtTxt: String
    let rain: Rain?
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: FiveMain
struct Main: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Double
    let seaLevel: Double
    let grndLevel: Double
    let humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: Rain
struct Rain: Codable {
    let threeH: Double?
    
    enum CodingKeys: String, CodingKey {
        case threeH = "3h"
    }
}

// MARK: Wind
struct Wind: Codable {
    let speed: Double
    let deg: Double?
}

// MARK: Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: Sys
struct Sys: Codable {
    let pod: String
}

// MARK: FiveWeather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: Weather Main
enum WeatherCondition: String {
    case clear = "Clear"
    case sunny = "Sunny"
    case clouds = "Clouds"
    case snow = "Snow"
    case rain = "Rain"
    case thunderstorm = "Thunderstorm"
}

