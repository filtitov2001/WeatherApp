//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by Felix Titov on 6/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

struct CurrentWeather: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    var temperatureString: String {
        String(format: "%.0f", main.temp)
    }
    var feelsLikeTemperatureString: String {
        String(format: "%.0f", main.feelsLike)
    }
    
    var systemIconNameString: String {
        guard let weatherCode = weather.first?.id else { return "nosign" }
        
        switch weatherCode {
        case 200...232: return "cloud.bolt.raint.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.max.fill"
        case 801...804: return "cloud.fill"
            
        default: return "nosign"
        }
    }
    
    init?(currentWeatherData: [String: Any]) {
        guard let name = currentWeatherData["name"] as? String else { return nil}
        
        guard let mainData = currentWeatherData["main"] else { return nil }
        guard let weatherData = currentWeatherData["weather"] else { return nil }
        
        guard let main = Main.getMain(from: mainData) else { return nil }
        let weather = Weather.getWeather(from: weatherData)
        
        self.name = name
        self.main = main
        self.weather = weather
    }
    
    static func getCurrentWeather(from value: Any) -> CurrentWeather? {
        guard let currentWeatherData = value as? [String: Any] else { return nil }
        return CurrentWeather(currentWeatherData: currentWeatherData)
    }
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    
    init?(mainData: [String: Any]) {
        guard let temp = mainData["temp"] as? Double else { return nil}
        guard let feelsLike = mainData["feels_like"] as? Double else { return nil }
        
        self.temp = temp
        self.feelsLike = feelsLike
    }
    
    static func getMain(from value: Any) -> Main? {
        guard let mainData = value as? [String: Any] else { return nil }
        return Main(mainData: mainData)
    }
    
    // Used in URLSession and Alomofire Decodable
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Decodable {
    let id: Int
    
    init?(weatherData: [String: Any]) {
        guard let id = weatherData["id"] as? Int else { return nil}
        
        self.id = id
    }
    
    static func getWeather(from value: Any) -> [Weather] {
        guard let weatherData = value as? [[String: Any]] else { return [] }
        return weatherData.compactMap { Weather(weatherData: $0) }
    }
}
