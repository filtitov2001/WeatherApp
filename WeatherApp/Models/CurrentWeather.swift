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
        "\(temperature.rounded())"
    }
    var feelsLikeTemperatureString: String {
        "\(feelsLikeTemperature.rounded())"
    }
    
    let feelsLikeTemperature: Double
    let conditionCode: Int
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}
