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
    @IBOutlet weak var updatedLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var helpers = Helpers()
    var dailyWeather: [DailyWeather] = []
    var swipeCount = 0
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var iconHasSpun = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe(sender: )))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe(sender: )))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeLeft)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        weatherIcon.addGestureRecognizer(tapRecognizer)
        weatherIcon.isUserInteractionEnabled = true
        
    }
    
    @objc func didSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                slideRight()
                swipeCount > 0 ? swipeCount -= 1 : nil
                
            default:
                slideLeft()
                swipeCount < dailyWeather.count - 1 ? swipeCount += 1 : nil
                
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            self.dayLabel.text = self.dailyWeather[self.swipeCount].day
            self.adviceLabel.text = self.dailyWeather[self.swipeCount].advice
            self.weatherIcon.image = UIImage(systemName: self.dailyWeather[self.swipeCount].iconName!)
        })
        
    }
    
    @objc func iconTapped() {
        if !iconHasSpun {
            rotateIcon()
        } else {
            scaleIcon()
        }
    }
    
    func fetchDailyWeather() {
        do{
            let request = DailyWeather.fetchRequest() as NSFetchRequest<DailyWeather>
            let sort = NSSortDescriptor(key: "sortId", ascending: true)
            request.sortDescriptors = [sort]
            self.dailyWeather =  try self.context.fetch(request)
            
            if dailyWeather != [] {
                DispatchQueue.main.async {
                    self.adviceLabel.text = self.dailyWeather[0].advice
                    self.dayLabel.text = self.dailyWeather[0].day
                    self.weatherIcon.image = UIImage(systemName: self.dailyWeather[0].iconName!)
                    self.updatedLabel.text = "Sist oppdatert: \(self.dailyWeather[0].updateTime!)"
                }
            } else {
                self.adviceLabel.text = "Ingen data"
                self.dayLabel.text = "Ingen data"
                self.weatherIcon.image = UIImage(systemName: "exclamationmark.icloud.fill")
                self.updatedLabel.text = "Ikke oppdatert"
            }
          
        } catch {
            print("Could not retrieve stored data")
        }
    }
}

//MARK: - WeatherManagerDelegate

extension HomeViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DailyWeather")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("There was an error deleting data")
        }
        var counter: Int64 = 0
        for weekday in weather.weekdays {
            let newDay = DailyWeather(context: self.context)
            
            newDay.sortId = counter
            newDay.day = helpers.dateStringToDay(dateString: weekday.day)
            newDay.updateTime = helpers.dateTimeString()
            
            
            // Added sleet to show rain. Because water from the skies == rain
            if weekday.condition.contains("rain") || weekday.condition.contains("sleet") {
                newDay.iconName = "umbrella.fill"
                newDay.advice = "Det blir regn i dag, ta med paraply! ☔️"
            } else {
                newDay.iconName = "sun.max.fill"
                newDay.advice = "Ikke noe regn i dag, la paraplyen bli hjemme! ☀️"
            }
            counter += 1
        }
        
        do {
            try self.context.save()
        } catch {
            print("There was an error saving data")
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

//MARK: - Animations
extension HomeViewController {
    func slideRight() {
        if swipeCount > 0 {
            UIView.animate(withDuration: 0.2, delay: 0, animations: { () -> Void in
                self.view.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 200)
                self.view.alpha = 0
            }, completion: {_ in
                UIView.animate(withDuration: 0.1, delay: 0, animations: {() -> Void in
                    self.view.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 200)
                }, completion: {_ in
                    UIView.animate(withDuration: 0.2, animations: {() -> Void in
                        self.view.transform = CGAffineTransform(translationX: self.view.bounds.width - self.view.bounds.width, y: 0)
                        self.view.alpha = 1
                    })
                })
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: [UIView.AnimationOptions.curveEaseInOut], animations: { () -> Void in
                self.view.transform = CGAffineTransform(translationX: 50, y: 0)
            } )
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [UIView.AnimationOptions.curveEaseInOut], animations: { () -> Void in
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            } )
            
        }
    }
    
    func slideLeft()  {
        if swipeCount != dailyWeather.count - 1{
            UIView.animate(withDuration: 0.2, delay: 0, animations: { () -> Void in
                self.view.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 200)
                self.view.alpha = 0
            }, completion: {_ in
                UIView.animate(withDuration: 0, delay: 0, animations: {() -> Void in
                    self.view.transform = CGAffineTransform(translationX: +self.view.bounds.width, y: 200)
                }, completion: {_ in
                    UIView.animate(withDuration: 0.2, animations: {() -> Void in
                        self.view.transform = CGAffineTransform(translationX: self.view.bounds.width - self.view.bounds.width, y: 0)
                        self.view.alpha = 1
                    })
                })
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: [UIView.AnimationOptions.curveEaseInOut], animations: { () -> Void in
                self.view.transform = CGAffineTransform(translationX: -50, y: 0)
            } )
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [UIView.AnimationOptions.curveEaseInOut], animations: { () -> Void in
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            } )
            
        }
    }
    
    func rotateIcon() {
        UIView.animate(withDuration: 3, delay: 0 , options: UIView.AnimationOptions.autoreverse, animations: { () -> Void in
            self.weatherIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.weatherIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: {_ in
            self.iconHasSpun = true
        })
    }
    
    func scaleIcon() {
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



