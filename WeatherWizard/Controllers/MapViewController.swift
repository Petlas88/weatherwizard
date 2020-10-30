//
//  MapViewController.swift
//  WeatherWizard
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController{
    
    var userLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    var pinLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationSwitch: UISwitch!
    
    var weatherManager = WeatherManager()
    var forecastViewController = ForecastViewController()
    var locationManager = CLLocationManager()
    var mapWeather = MapWeather()
    var mapWeatherView = MapWeather() // Reassign to "let" in didLoad if view is not to be hidden before long tap
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        mapWeather.delegate = self
        
        mapWeatherView = MapWeather(frame: CGRect(x: 0.0, y: self.view.bounds.height - (self.view.bounds.height * 0.25), width: self.view.bounds.width, height: self.view.bounds.height * 0.25))
        self.view.addSubview(mapWeatherView)
        mapWeatherView.isHidden = true
        
        
        mapView.showsUserLocation = true
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        mapView.addGestureRecognizer(longTapGesture)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationSwitch.isOn = false
        
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        //        Want to get position everytime the view appears
    //
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let tabbar = tabBarController as! MainTabBarController
        tabbar.tabBarLat = userLocation.coordinate.latitude
        tabbar.tabBarLon = userLocation.coordinate.longitude
    }
    
    @IBAction func locationSwitchToggled(_ sender: UISwitch) {
        if !locationSwitch.isOn {
            panToLocation(userLocation)
            let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
            mapView.removeAnnotations(annotations)
        } else {
            if pinLocation.latitude == 0.0 && pinLocation.longitude == 0.00 {
                pinLocation = mapView.centerCoordinate
            }
            addAnnotation(location: CLLocationCoordinate2D(latitude: pinLocation.latitude, longitude: pinLocation.longitude))
        }
        
        mapView.showsUserLocation = !locationSwitch.isOn
    }
}

//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            locationManager.stopUpdatingLocation()
            panToLocation(location)
            userLocation = location
           
            
            
        }
    }
    
    func panToLocation(_ location: CLLocation) {
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09))
        
        mapView.setRegion(region, animated: true)
    }
    
    @objc func didLongPress(sender: UIGestureRecognizer) {
        if locationSwitch.isOn  {
            if sender.state == .began {
                let locationInView = sender.location(in: mapView)
                let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
                addAnnotation(location: locationOnMap)
                mapWeatherView.isHidden = false
                NSLayoutConstraint.activate([
                    mapView.bottomAnchor.constraint(equalTo: mapWeatherView.topAnchor) // Put in didLoad if bottom view is not to be hidden before long press.
                ])
            }
        } else {
            return
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        
        let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
        mapView.removeAnnotations(annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "\(annotation.coordinate.latitude) \(annotation.coordinate.longitude)"
        mapView.addAnnotation(annotation)
        
        let convertedLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        panToLocation(convertedLocation)
        pinLocation = location
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("changed")
    }
}


//MARK: - WeatherManagerDelegate

extension MapViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        didGetData()
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - MapWeatherDelegate

extension MapViewController: MapWeatherDelegate {
    func didGetData() {
        
    }
}
