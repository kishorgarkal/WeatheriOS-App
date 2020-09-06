//
//  ViewController.swift
//  WeatherApp
//
//  Created by Kishor on 09/06/20.
//  Copyright © 2020 Kishor. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    let networkManager = WeatherNetworkManager()
    
    @IBOutlet weak var WeatherView: UIView!
    @IBOutlet weak var currentLocation: UILabel!
    
    @IBOutlet weak var currentTime: UILabel!
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    @IBOutlet weak var tempDescription: UILabel!
    
    
    @IBOutlet weak var tempSymbol: UIImageView!
    
    @IBOutlet weak var maxTemp: UILabel!
    
    @IBOutlet weak var minTemp: UILabel!
    
    var currentLoc: CLLocation?
    var stackView : UIStackView!
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton)),UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))]
        
        // corner radius
        WeatherView.layer.cornerRadius = 20

        // border
        WeatherView.layer.borderWidth = 1.0
        WeatherView.layer.masksToBounds = true
        // shadow
        WeatherView.layer.shadowColor = UIColor.black.cgColor
        WeatherView.layer.shadowOffset = CGSize(width: 3, height: 3)
        WeatherView.layer.shadowOpacity = 0.7
        WeatherView.layer.shadowRadius = 20.0
        
        currentLocation.textColor = .black
        currentTime.textColor = .black
        currentTemperatureLabel.textColor = .black
        tempDescription.textColor = .black
        maxTemp.textColor = .black
        minTemp.textColor = .black
        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
        transparentNavigationBar()
        
    }
    
    
    
    
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
            print("Current Temperature", weather.main.temp.kelvinToCeliusConverter())
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy" //yyyy
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            DispatchQueue.main.async {
                self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
                self.currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                self.tempDescription.text = weather.weather[0].description
                self.currentTime.text = stringDate
                self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
                self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                self.tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
            }
        }
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
            print("Current Temperature", weather.main.temp.kelvinToCeliusConverter())
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy" //yyyy
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            DispatchQueue.main.async {
                self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
                self.currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                self.tempDescription.text = weather.weather[0].description
                self.currentTime.text = stringDate
                self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
                self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                self.tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
            }
        }
    }
    
    
    //MARK: - Handlers
    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "City Name"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("City Name: \(firstTextField.text)")
            guard let cityname = firstTextField.text else { return }
            self.loadData(city: cityname)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @objc func handleRefresh() {
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadData(city: city)
    }
    
    
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        
    }
    
}

