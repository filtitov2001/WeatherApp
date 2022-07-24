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
            return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apiKey=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            return "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apiKey=\(apiKey)&units=metric"
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var onComplition: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        let urlString = requestType.urlString
        
//        switch requestType {
//            case .cityName(let city):
//            urlString = requestType.urlString
//                urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apiKey=\(apiKey)&units=metric"
//            case .coordinate(let latitude, let longitude):
//                urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apiKey=\(apiKey)&units=metric"
//        }
        
        performRequest(withURLString: urlString)
    }
    
    fileprivate func performRequest(withURLString URLString: String) {
        guard let url = URL(string: URLString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onComplition?(currentWeather)
                }
            }
        }.resume()
        
    }
    
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        
        do {
            let currentWeatherData = try JSONDecoder().decode(CurrentWeather.self, from: data)
            let currentWeather = CurrentWeather(name: "Foo", main: Main(temp: 1.0, feelsLike: 1.0), weather: [Weather(id: 0)])
           
            
            return currentWeather
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
