//
//  MapViewController.swift
//  WeatherWizard
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController{
    
    var lat: CLLocationDegrees = 0.0
    var lon: CLLocationDegrees = 0.0
    
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var weatherManager = WeatherManager()
    var forecastViewController = ForecastViewController()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        mapView.addGestureRecognizer(longTapGesture)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        Want to get position everytime the view appears
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as! MainTabBarController
        tabbar.tabBarLat = lat
        tabbar.tabBarLon = lon
    }
    
    
}

//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(type(of: locations.first))
        if let location = locations.first {
            
            lon = location.coordinate.longitude
            lat =  location.coordinate.latitude
            
            locationManager.stopUpdatingLocation()
            
            panToLocation(location)
        }
    }
    
    func panToLocation(_ location: CLLocation) {
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    @objc func longPress(sender: UIGestureRecognizer) {
       
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "\(annotation.coordinate.latitude) \(annotation.coordinate.longitude)"
        self.mapView.addAnnotation(annotation)
        
        let convertedLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        panToLocation(convertedLocation)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("changed")
    }
}


//MARK: - WeatherManagerDelegate

extension MapViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print("Kek Weather!")
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
