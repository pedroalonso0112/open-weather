//
//  AppConfiguration.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/5.
//

import Foundation

final class AppConfiguration {
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    
    lazy var apiUrl: String = {
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "ApiUrl") as? String else {
            fatalError("ApiUrl must not be empty in plist")
        }
        return apiUrl
    }()
}
