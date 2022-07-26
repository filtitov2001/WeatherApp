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
    
    @IBOutlet weak var temperatureView: UIView!
    @IBOutlet weak var feelsLikeView: UIView!
    @IBOutlet weak var cityView: UIView!
    
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        startAnimating()
        
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        presentUIAlertController(
            withTitle: "Enter city name",
            andMessage: nil,
            style: .alert,
            withSearch: true
        ) { [unowned self] cityName in
            
            self.getData(requestType: .cityName(city: cityName))
        }
    }
    
    //MARK: - Fetching Data
    private func getData(requestType: RequestType) {
        // Parsing with URLSession
        NetworkManager.shared.fetchCurrentWeather(
            dataType: CurrentWeather.self,
            forRequestType: requestType
        ) { [unowned self] result in
            switch result {
                
            case .success(let currentWeather):
                self.startAnimating()
                self.updateUI(with: currentWeather)
            case .failure(let error):
                self.presentUIAlertController(
                    withTitle: "Error",
                    andMessage: error.rawValue,
                    style: .alert,
                    withSearch: false,
                    completionHandler: nil
                )
            }
        }
        
        // Parsing with Alamofire Decodable
                /*
                AlamofireNetworkManager.shared.fetchCurrentWeather(
                    forRequestType: requestType) { result in
                        switch result {
                        case .success(let currentWeather):
                            self.startAnimating()
                            self.updateUI(with: currentWeather)
                        case .failure(let error):
                            self.presentUIAlertController(
                                withTitle: "Error",
                                andMessage: error.rawValue,
                                style: .alert,
                                withSearch: false,
                                completionHandler: nil
                            )
                        }
                    }
                */
        
        // Parsing with Alamofire with manually parsing
        //It's just for understading how decode method works
        /*
         AlamofireNetworkManager.shared.fetchCurrentWeatherWithJSONParsing(
         forRequestType: requestType) { result in
         switch result {
         case .success(let currentWeather):
         self.startAnimating()
         self.updateUI(with: currentWeather)
         case .failure(let error):
         self.presentUIAlertController(
         withTitle: "Error",
         andMessage: error.rawValue,
         style: .alert,
         withSearch: false,
         completionHandler: nil
         )
         
         }
         }
         */
    }
}

//MARK: - Work with UI
extension ViewController {
    private func updateUI(with weather: CurrentWeather) {
        self.cityLabel.text = weather.name
        self.temperatureLabel.text = weather.temperatureString + " °C"
        self.feelsLikeTemperatureLabel.text = "Feels like \(weather.feelsLikeTemperatureString) °C"
        self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        
        stopAnimating()
    }
    
    private func setupViews() {
        let cornerRadius: CGFloat = 10
        
        weatherIconImageView.layer.cornerRadius = cornerRadius
        
        cityView.layer.cornerRadius = cornerRadius
        temperatureView.layer.cornerRadius = cornerRadius
        feelsLikeView.layer.cornerRadius = cornerRadius
        
    }
    
    private func startAnimating() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: [.autoreverse, .repeat]) {
                self.weatherIconImageView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9960784314, blue: 0.7058823529, alpha: 0.5)
                self.feelsLikeView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9960784314, blue: 0.7058823529, alpha: 0.5)
                self.cityView.backgroundColor =  #colorLiteral(red: 0.9647058824, green: 0.9960784314, blue: 0.7058823529, alpha: 0.5)
                self.temperatureView.backgroundColor =  #colorLiteral(red: 0.9647058824, green: 0.9960784314, blue: 0.7058823529, alpha: 0.5)
                
            }
    }
    
    private func stopAnimating() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0) {
                self.weatherIconImageView.backgroundColor = .clear
                self.cityView.backgroundColor = .clear
                self.temperatureView.backgroundColor = .clear
                self.feelsLikeView.backgroundColor = .clear
            }
    }
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        getData(requestType: .coordinate(latitude: latitude, longitude: longitude))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
