//
//  ViewController.swift
//  WeatherWizard
//


import UIKit
import CoreLocation
import CoreData


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
    var helpers = Helpers()
    var dailyHours: [String] = []
    var dailyWeather: [DailyWeather]?
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    func fetchDailyWeather() {
        do{
            self.dailyWeather =  try self.context.fetch(DailyWeather.fetchRequest())
            print(dailyWeather!.count)
            let day = dailyWeather![0]
            
            DispatchQueue.main.async {
                self.adviceLabel.text = day.advice
                self.dayLabel.text = day.day
                self.weatherIcon.image = UIImage(systemName: day.iconName!)
            }
        } catch {
            print("Could not retrieve stored data")
        }
    }
}

//MARK: - WeatherManagerDelegate

extension HomeViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        dailyHours.append(weather.twelveHourCondition)
        dailyHours.append(weather.sixHourCondition)
        dailyHours.append(weather.oneHourCondition)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DailyWeather")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print(error)
        }

        let weekday = helpers.dateStringToDay(dateString: weather.time)
        let newDay = DailyWeather(context: self.context)
        
        newDay.day = weekday
        for hour in self.dailyHours {
            // Added sleet to show rain. Because water from the skies == rain
            if hour.contains("rain") || hour.contains("sleet") {
                newDay.iconName = "umbrella.fill"
                newDay.advice = "Det blir regn i dag, ta med paraply! ☔️"
            } else {
                newDay.iconName = "sun.max.fill"
                newDay.advice = "Ikke noe regn i dag, la paraplyen bli hjemme! ☀️"
            }
        }
        do {
            try self.context.save()
        } catch {
            print("Error")
        }
        
        self.fetchDailyWeather()
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nettverksfeil", message: "Vi kunne ikke finne oppdatert værinformasjon. Været som vises er lagret tidligere og kan være utdatert.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            self.fetchDailyWeather()
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



