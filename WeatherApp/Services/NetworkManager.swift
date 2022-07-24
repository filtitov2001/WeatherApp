//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Felix Titov on 6/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation
import CoreLocation

enum RequestType {
    
    case cityName(city: String)
    case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    
    var urlString: String {
        switch self {
        case .cityName(let city):
            return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apiKey=\(API.apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            return "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apiKey=\(API.apiKey)&units=metric"
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var onComplition: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        guard let url = URL(string: requestType.urlString) else { return }
        
        //     performRequest(withURLString: urlString)
    }
    
//    fileprivate func performRequest(withURLString URLString: String) {
//        guard let url = URL(string: URLString) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                if let currentWeather = self.parseJSON(withData: data) {
//                    self.onComplition?(currentWeather)
//                }
//            }
//        }.resume()
//
//    }
    
    fileprivate func parseJSON<T: Decodable>(withData data: Data, completion: (Result<T, Error>) -> Void) {
        do {
            let currentWeather = try JSONDecoder().decode(T.self, from: data)
            completion(.success(currentWeather))
        } catch let error {
            completion(.failure(error))
        }
        
    }
}

