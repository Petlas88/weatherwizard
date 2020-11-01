//
//  MapWeather.swift
//  WeatherWizard
//

import UIKit
import MapKit

class MapWeather: UIView {
    
    var weatherManager = WeatherManager()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latDegreesLabel: UILabel!
    @IBOutlet weak var lonDegreesLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame:  frame)
        weatherManager.delegate = self
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        weatherManager.delegate = self
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed(K.mapWeatherName, owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    func locationDidChange(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        weatherManager.fetchWeather(lat: lat, lon: lon)
    }
}

//MARK: - WeatherManagerDelegate

extension MapWeather: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.latDegreesLabel.text = weather.latitude
            self.lonDegreesLabel.text = weather.longitude
            self.weatherIcon.image =  UIImage(named: weather.oneHourCondition)
            // oneHourCondition corresponds to icon names found in assets.
            // The icons are downloaded from the following link: https://api.met.no/weatherapi/weathericon/2.0/documentation under Usage.
            // The weather icons are copyright (c) 2015-2017 Yr and licensed under the MIT License.
            // See https://github.com/YR/weather-symbols/blob/master/LICENSE for more information.
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            let parentView: UIViewController = UIApplication.shared.windows[0].rootViewController!
            let alert = UIAlertController(title: "🥶", message: "Vi kunne desverre ikke finne været akkurat nå. Venligst prøv igjen senere. ☀️", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            parentView.present(alert, animated: true, completion: nil)
        }
    }
}
