//
//  ViewController.swift
//  WeatherWizard
//


import UIKit
import CoreLocation


class HomeViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var drop1: UIImageView!
    @IBOutlet weak var drop2: UIImageView!
    @IBOutlet weak var drop3: UIImageView!
    @IBOutlet weak var drop4: UIImageView!
    
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var dailyHours: [String] = []
    
    var iconHasSpun = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        weatherIcon.addGestureRecognizer(tapRecognizer)
        weatherIcon.isUserInteractionEnabled = true
    }
    
    @objc func iconTapped() {
        if !iconHasSpun {
            UIView.animate(withDuration: 3, delay: 0 , options: UIView.AnimationOptions.autoreverse, animations: { () -> Void in
                self.weatherIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.weatherIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: {_ in 
                self.iconHasSpun = true
            })
        } else {
            UIView.animate(withDuration: 2, animations: {() -> Void in
                self.weatherIcon.transform = CGAffineTransform(scaleX: 3, y: 3)
            })
            UIView.animate(withDuration: 2, delay: 2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                self.weatherIcon.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }, completion: {_ in
                self.iconHasSpun = false
            })
        }
    }
}

//MARK: - WeatherManagerDelegate

extension HomeViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        dailyHours.append(weather.oneHourCondition)
        dailyHours.append(weather.sixHourCondition)
        dailyHours.append(weather.twelveHourCondition)
        
        let timeRemovedT = weather.time.replacingOccurrences(of: "T", with: " ")
        let formattedTime = timeRemovedT.replacingOccurrences(of: "Z", with: ".0")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
        let date = dateFormatter.date(from: formattedTime)!
        dateFormatter.dateFormat = "cccc"
        dateFormatter.locale = Locale(identifier: "no_NO")
        let weekday = dateFormatter.string(from: date)

        
        DispatchQueue.main.async {
            self.dayLabel.text = weekday.capitalized
            for hour in self.dailyHours {
                if hour.contains("rain") {
                    self.weatherIcon.image = UIImage(systemName: "umbrella.fill")
                    self.adviceLabel.text = "Det blir regn i dag, ta med paraply! ☔️"
                } else {
                    self.weatherIcon.image = UIImage(systemName: "sun.max.fill")
                    self.adviceLabel.text = "Ingen regn i dag, la paraplyen bli hjemme! ☀️"
                }
            }
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nettverksfeil", message: "Vi kunne ikke finne oppdatert værinformasjon. Været som vises er lagret tidligere.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Authorization changed")
    }
}

//MARK: - StringProtocol extension
extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

