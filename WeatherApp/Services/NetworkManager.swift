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
            return API.url.rawValue + API.version.rawValue + "?q=\(city)&apiKey=\(API.apiKey)&units=\(API.units.rawValue)"
            
        case .coordinate(let latitude, let longitude):
            return API.url.rawValue + API.version.rawValue + "?lat=\(latitude)&lon=\(longitude)&apiKey=\(API.apiKey)&units=\(API.units.rawValue)"
        }
    }
}

enum NetworkError: String, Error {
    case invalidURL = "Invalid URL!"
    case noData = "Unnable to fetch data!"
    case decodingError = "Decoding data error!"
    case serverError = "Server error!"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCurrentWeather<T: Decodable>(dataType: T.Type, forRequestType requestType: RequestType, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: requestType.urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        performRequest(dataType: dataType, withURL: url) { result in
            switch result {
                
            case .success(let currentWeather):
                DispatchQueue.main.async {
                    completion(.success(currentWeather))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                    
                }
            }
        }
    }
    
    fileprivate func performRequest<T: Decodable>(dataType: T.Type, withURL url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {

        URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
            if let error = error {
                completion(.failure(error as? NetworkError ?? .serverError))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            self.parseJSON(withData: data) { result in
                completion(result)
            }
        }.resume()

    }
    
    fileprivate func parseJSON<T: Decodable>(withData data: Data, completion: (Result<T, NetworkError>) -> Void) {
        do {
            let currentWeather = try JSONDecoder().decode(T.self, from: data)
            completion(.success(currentWeather))
        } catch let error {
            completion(.failure(error as? NetworkError ?? .decodingError))
        }
        
    }
}

