//
//  ViewController + UIAlertController.swift
//  WeatherApp
//
//  Created by Felix Titov on 6/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

extension ViewController {
    func presentUIAlertController(
        withTitle title: String?,
        andMessage message: String?,
        style: UIAlertController.Style
    ) {
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        
        alertController.addTextField { textField in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
            
            textField.placeholder = cities.randomElement()
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { action in
            let textField = alertController.textFields?.first
            
            guard let cityName = textField?.text else { return }
            
            if !cityName.isEmpty {
                print("search info for the \(cityName)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

