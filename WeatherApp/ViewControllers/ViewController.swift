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
    
    var networkWeatherManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkWeatherManager.onComplition = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateUI(with: currentWeather)
        }
        
        networkWeatherManager.fetchCurrentWeather(for: "London")
        
        
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        presentUIAlertController(withTitle: "Enter city name", andMessage: nil, style: .alert) { [unowned self] cityName in
            self.networkWeatherManager.fetchCurrentWeather(for: cityName)
        }
    }
    
    func updateUI(with weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString + " °C"
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
    
}

