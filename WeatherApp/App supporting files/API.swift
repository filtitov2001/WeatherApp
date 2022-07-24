//
//  Constants.swift
//  WeatherApp
//
//  Created by Felix Titov on 6/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

enum API: String {
    case url = "https://api.openweathermap.org/"
    case version = "data/2.5/weather"
    
    case units = "metric"
    
    static var apiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "apiKey") as! String
    }
    
}


