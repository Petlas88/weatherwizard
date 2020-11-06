//
//  ViewController.swift
//  WeatherWizard
//
//  The PageViewController part of this ViewController was developed watching a youtube tutorial.
//  Link to tutorial: https://www.youtube.com/watch?v=hIMRn_LdvOg&t=1257s


import UIKit
import CoreLocation
import CoreData


class HomeViewController: UIViewController {
    
    @IBOutlet weak var weatherView: UIView!
    
    var dataSource: [Day] = []
    var currentViewControllerIndex = 0
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var helpers = Helpers()
    var dailyWeather: [DailyWeather] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var iconHasSpun = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func configurePageViewController() {
        guard let pageViewController = storyboard?.instantiateViewController(identifier: String(describing: HomePageViewController.self)) as? HomePageViewController else {return}
        
        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        proxy.currentPageIndicatorTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        weatherView.addSubview(pageViewController.view)
        
        let views: [String: Any] = ["pageView": pageViewController.view!]
        
        weatherView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        weatherView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        
        guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else {
            return
            
        }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }
    
    func detailViewControllerAt(index: Int) -> DayViewController? {
        if index >= dataSource.count || dataSource.count == 0 {
            return nil
        }
        
        guard let dayViewController = storyboard?.instantiateViewController(identifier: String(describing: DayViewController.self)) as? DayViewController else {
            return nil
        }
        
        dayViewController.index = index
        
        //  Checking additional array (dataSource) to be able to add "error" page. Could've gotten the data straight from Core Data. But PageViewController makes it difficult to add formentioned page that way.
        
            dayViewController.dayName = self.dataSource[index].dayName
            dayViewController.iconName = self.dataSource[index].iconName
            dayViewController.message = self.dataSource[index].message
            dayViewController.updateTime = self.dataSource[index].updateTime

        return dayViewController
    }
    
    func fetchStoredWeather() {
        do{
            let request = DailyWeather.fetchRequest() as NSFetchRequest<DailyWeather>
            let sort = NSSortDescriptor(key: "sortId", ascending: true)
            request.sortDescriptors = [sort]
            self.dailyWeather =  try self.context.fetch(request)
            
            // Pushing to additional array (dataSource) and add an instance of struct Day to be able to add "error" page if no data is found and there's no internet connection
            if !dailyWeather.isEmpty {
                for day in dailyWeather {
                    dataSource.append(Day(dayName: day.day!, message: day.advice!, iconName: day.iconName!, updateTime: "Sist oppdatert: \(day.updateTime!)" ))
                }
            } else {
                dataSource.append(Day(dayName: "Ingen data", message: "Ingen data", iconName: "exclamationmark.icloud.fill", updateTime: "Ikke oppdatert"))
            }
            
        } catch {
            print("Could not retrieve stored data: \(error)")
        }
        
        DispatchQueue.main.async {
            self.configurePageViewController()
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
            print("There was an error deleting data \(error)")
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
                newDay.advice = "Det blir regn, ta med paraply! ☔️"
            } else {
                newDay.iconName = "sun.max.fill"
                newDay.advice = "Ikke noe regn, la paraplyen bli hjemme! ☀️"
            }
            counter += 1
        }
        
        do {
            try self.context.save()
        } catch {
            print("There was an error saving data: \(error)")
        }
        
        self.fetchStoredWeather()
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nettverksfeil", message: "Vi kunne ikke finne oppdatert værinformasjon. Været som vises er lagret tidligere og kan være utdatert.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            self.fetchStoredWeather()
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

//MARK: - PageViewController

extension HomeViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        dataSource.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let dayViewController = viewController as? DayViewController
        
        guard var currentIndex = dayViewController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return detailViewControllerAt(index: currentIndex)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dayViewController = viewController as? DayViewController
        
        guard var currentIndex = dayViewController?.index else {
            return nil
        }
        
        if currentIndex == dataSource.count {
            return nil
        }
        
        currentIndex += 1
        
        currentViewControllerIndex = currentIndex
        
        return detailViewControllerAt(index: currentIndex)
    }
}




