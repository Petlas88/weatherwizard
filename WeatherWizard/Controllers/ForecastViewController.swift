//
//  ForecastViewController.swift
//  WeatherWizard
//


import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    
    var forecasts: [Forecast] = []
    
    var currentLat: CLLocationDegrees = 0.0
    var currentLon: CLLocationDegrees = 0.0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = ""
        coordinatesLabel.text = ""
        
        weatherManager.delegate = self
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        let tabbar = tabBarController as! MainTabBarController
        //        Calling fetchWeather here to not update everytime view appears. Also checking if user has fetched current location. Will not fetch weather if that's the case
        if currentLat != tabbar.tabBarLat, currentLon != tabbar.tabBarLon {
            currentLat = 59.911166
            currentLon = 10.744810
            weatherManager.fetchWeather(lat: currentLat, lon: currentLon)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tabbar = tabBarController as! MainTabBarController
        //        Weather should not be fetched if coordinate from map is allready shown or if coordinates in MainTabBarController == nil
        if tabbar.tabBarLat != currentLat, tabbar.tabBarLon != currentLon, tabbar.tabBarLat != nil, tabbar.tabBarLon != nil {
            
            forecasts = []
            currentLat = tabbar.tabBarLat!
            currentLon = tabbar.tabBarLon!
            weatherManager.fetchWeather(lat: currentLat, lon: currentLon)
            
            DispatchQueue.main.async {
                self.locationLabel.text = "Din lokasjon"
                self.coordinatesLabel.text = "\(self.currentLat), \(self.currentLon)"
                self.tableView.reloadData()
            }
        }
    }
}


//MARK: - WeatherManagerDelegate

extension ForecastViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        forecasts.append(Forecast(timeSpan: "Nå", degrees: weather.temperature))
        forecasts.append(Forecast(timeSpan: "Neste time",  condition: weather.getWeatherCondition(timeSpan: weather.oneHourCondition), precipitation: weather.oneHourRain))
        forecasts.append(Forecast(timeSpan: "Neste 6 timer", condition: weather.getWeatherCondition(timeSpan: weather.sixHourRain), precipitation: weather.sixHourRain))
        forecasts.append(Forecast(timeSpan: "Neste 12 timer", condition: weather.getWeatherCondition(timeSpan: weather.twelveHourCondition)))
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - UITableViewDataSource

extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
            as! ForecastCell
        cell.timeLabel.text = forecasts[indexPath.row].timeLabel
        cell.weatherLabel.text = forecasts[indexPath.row].weatherLabel
        cell.temperatureLabel.text = forecasts[indexPath.row].tempLabel
        cell.conditionLabel.text = forecasts[indexPath.row].condition
        cell.degreesLabel.text = forecasts[indexPath.row].degrees
        cell.rainLabel.text = forecasts[indexPath.row].rain
        return cell
    }
}

