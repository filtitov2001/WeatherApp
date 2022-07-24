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
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Decodable {
    let id: Int
}
