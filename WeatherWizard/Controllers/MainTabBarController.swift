//
//  MainTabBarController.swift
//  WeatherWizard
//


import UIKit
import CoreLocation

class MainTabBarController: UITabBarController {
    
    //  Coordinates to send to ForecastViewController
    var tabBarLat: CLLocationDegrees? = nil
    var tabBarLon: CLLocationDegrees? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
