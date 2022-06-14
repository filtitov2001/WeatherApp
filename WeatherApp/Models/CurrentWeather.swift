//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Felix Titov on 6/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

struct CurrentWeather {
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        String(format: "%.0f", temperature)
    }
    var feelsLikeTemperatureString: String {
       String(format: "%.0f", feelsLikeTemperature)
    }
    
    let feelsLikeTemperature: Double
    let conditionCode: Int
    
    var systemIconNameString: String {
        switch conditionCode {
            case 200...232: return "cloud.bolt.raint.fill"
            case 300...321: return "cloud.drizzle.fill"
            case 500...531: return "cloud.rain.fill"
            case 600...622: return "cloud.snow.fill"
            case 701...781: return "smoke.fill"
            case 800: return "sin.min.fill"
            case 801...804: return "cloud.fill"
            
            default: return "nosign"
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}
