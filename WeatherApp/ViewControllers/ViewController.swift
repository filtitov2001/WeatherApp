//
//  ViewController.swift
//  WeatherApp
//
//  Created by Felix Titov on 6/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    private var networkWeatherManager = NetworkManager()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.autoreverse, .repeat]
        ) {
            self.weatherIconImageView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9960784314, blue: 0.7058823529, alpha: 0.5)
        }

        
//        UIView.animate(withDuration: 5) {
//            self.weatherIconImageView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
//            self.weatherIconImageView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9960784314, blue: 0.7058823529, alpha: 0.5)
//        }
        
//        networkWeatherManager.onComplition = { [weak self] currentWeather in
//            guard let self = self else { return }
//            self.updateUI(with: currentWeather)
//        }
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestLocation()
//        }
        
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        presentUIAlertController(withTitle: "Enter city name", andMessage: nil, style: .alert) { [unowned self] cityName in
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: cityName))
        }
    }
    
    func updateUI(with weather: CurrentWeather) {
        DispatchQueue.main.async {
     //       self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString + " °C"
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
    
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
