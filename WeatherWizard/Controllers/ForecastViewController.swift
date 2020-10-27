//
//  ForecastViewController.swift
//  WeatherWizard
//
//  Created by Lasse Pettersen on 26/10/2020.
//

import UIKit

class ForecastViewController: UIViewController {
    
    var forecasts: [Forecast] = [
        Forecast(time: "Nå", weather: "Vær", temperature: "Temperatur", condition: "Overskyet", degrees: "8", rain: "10mm"),
        Forecast(time: "Om 6 timer", weather: "Vær", temperature: "", condition: "Sol", degrees: "", rain: "0mm"),
        Forecast(time: "Om 12 timer", weather: "Vær", temperature: "", condition: "Torden", degrees: "", rain: "23mm")
    ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.fetchWeather(lat: 59.911166, lon: 10.744810)
            
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    
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
        cell.timeLabel.text = forecasts[indexPath.row].time
        cell.weatherLabel.text = forecasts[indexPath.row].weather
        cell.temperatureLabel.text = forecasts[indexPath.row].temperature
        cell.conditionLabel.text = forecasts[indexPath.row].condition
        cell.degreesLabel.text = forecasts[indexPath.row].degrees
        cell.rainLabel.text = forecasts[indexPath.row].rain
        return cell
    }
    
    
}

