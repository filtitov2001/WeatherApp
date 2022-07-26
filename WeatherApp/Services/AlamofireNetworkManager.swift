//
//  AlamofireNetworkManager.swift
//  WeatherApp
//
//  Created by Felix Titov on 7/26/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Alamofire

class AlamofireNetworkManager {
    static let shared = AlamofireNetworkManager()
    
    private init() {}
    
    func fetchCurrentWeather(
        forRequestType requestType: RequestType,
        completion: @escaping (Result<CurrentWeather, NetworkError>) -> Void
    ) {
        AF.request(requestType.urlString)
            .validate()
            .responseDecodable(of: CurrentWeather.self) { dataResponse in
                switch dataResponse.result {
                    
                case .success(let currentWeather):
                    DispatchQueue.main.async {
                        completion(.success(currentWeather))
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }
            }
    }
    
    func fetchCurrentWeatherWithJSONParsing(
        forRequestType requestType: RequestType,
        completion: @escaping (Result<CurrentWeather, NetworkError>) -> Void
    ) {
        AF.request(requestType.urlString)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                    
                case .success(let value):
                    guard let currentWeather = CurrentWeather.getCurrentWeather(from: value) else {
                        DispatchQueue.main.async {
                            completion(.failure(.decodingError))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.success(currentWeather))
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }
            }
    }
}
