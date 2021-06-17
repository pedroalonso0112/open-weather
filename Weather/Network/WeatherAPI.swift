//
//  WeatherService.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/5.
//

import Foundation
import Alamofire

enum Result<Data: Decodable> {
    case success(Data)
    case failure(String?)
}

typealias Handler = (Result<Data>) -> Void

final class WeatherAPI {
    
    lazy var config = AppConfiguration()
    
    static let instance = WeatherAPI()
    
    func weatherDataAt(latitude: Double, longitude: Double, callback: @escaping Handler) {
        let url = config.apiUrl
        let apiKey = config.apiKey
        
        let params: [String: Any] = [
            "lat" : latitude,
            "lon" : longitude,
            "appid" : apiKey
        ]
        
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in

            switch response.response?.statusCode {
            case 200:
                callback(.success(response.data!))
                break
            default:
                callback(.failure(response.error?.localizedDescription))
                break;
            }
        }
    }
    
}


