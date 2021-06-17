//
//  WeatherUIConfiguration.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/6.
//

import Foundation
import UIKit

struct WeatherConfiguration {
    struct Colors {
        static let SunnyTopColor = UIColor(red: 227 / 255.0, green: 101 / 255.0, blue: 80 / 255.0, alpha: 1.0)
        static let SunnyBottomColor = UIColor(red: 236 / 255.0, green: 187 / 255.0, blue: 105 / 255.0, alpha: 1.0)
        
        static let CloudsTopColor = UIColor(red: 185 / 255.0, green: 198 / 255.0, blue: 214 / 255.0, alpha: 1.0)
        static let CloudsBottomColor = UIColor(red: 121 / 255.0, green: 131 / 255.0, blue: 141 / 255.0, alpha: 1.0)
        
        static let ThunderTopColor = UIColor(red: 6 / 255.0, green: 89 / 255.0, blue: 99 / 255.0, alpha: 1.0)
        static let ThunderBottomColor = UIColor(red: 226 / 255.0, green: 238 / 255.0, blue: 164 / 255.0, alpha: 1.0)
        
        static let RainTopColor = UIColor(red: 5 / 255.0, green: 61 / 255.0, blue: 117 / 255.0, alpha: 1.0)
        static let RainBottomColor = UIColor(red: 0 / 255.0, green: 152 / 255.0, blue: 177 / 255.0, alpha: 1.0)
        
        
        static let SnowTopColor = UIColor(red: 5 / 255.0, green: 61 / 255.0, blue: 117 / 255.0, alpha: 1.0)
        static let SnowBottomColor = UIColor(red: 9 / 255.0, green: 152 / 255.0, blue: 177 / 255.0, alpha: 1.0)
    }
    
    struct Images {
        static let Sunny = UIImage(named: "Sunny")
        static let Clouds = UIImage(named: "Clouds")
        static let Thunder = UIImage(named: "Thunder")
        static let Rain = UIImage(named: "Rain")
        static let Snow = UIImage(named: "Snow")
    }
    
    struct DefaultLocation {
        static let latitude = 43.7001
        static let longitude = -79.4163
    }
    
}
