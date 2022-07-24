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
            return API.url.rawValue + API.version.rawValue + "?q=\(city)&apiKey=\(API.apiKey)&units=\(API.units)"
        case .coordinate(let latitude, let longitude):
            return API.url.rawValue + API.version.rawValue + "?lat=\(latitude)&lon=\(longitude)&apiKey=\(API.apiKey)&units=\(API.units)"
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCurrentWeather<T: Decodable>(forRequestType requestType: RequestType, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: requestType.urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error as? NetworkError ?? .serverError))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let currentWeather = try JSONDecoder().decode(T.self, from: data)
                completion(.success(currentWeather))
            } catch let error {
                completion(.failure(error as? NetworkError ?? .decodingError))
            }
            
        }.resume()
    }
}

