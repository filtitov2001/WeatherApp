//
//  ViewController.swift
//  WeatherApp
//
//  Created by Felix Titov on 6/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    let networkWeatherManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkWeatherManager.fetchCurrentWeather(for: "London")
        
        
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        presentUIAlertController(withTitle: "Enter city name", andMessage: nil, style: .alert) { cityName in
            self.networkWeatherManager.fetchCurrentWeather(for: cityName)
        }
    }
    
}

