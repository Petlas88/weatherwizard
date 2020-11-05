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
    @IBOutlet weak var pinModeImage: UIImageView!
    @IBOutlet weak var userLocationModeImage: UIImageView!
    @IBOutlet weak var locationSwitchStack: UIStackView!
    @IBOutlet weak var mapWeather: MapWeather!
    
    var forecastViewController = ForecastViewController()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
    
        mapView.showsUserLocation = true
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        mapView.addGestureRecognizer(longTapGesture)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        locationSwitchStack.layer.cornerRadius = 10
        locationSwitch.isOn = false
        
        
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let tabbar = tabBarController as! MainTabBarController
        tabbar.tabBarLat = userLocation.coordinate.latitude
        tabbar.tabBarLon = userLocation.coordinate.longitude
    }
    
    @IBAction func locationSwitchToggled(_ sender: UISwitch) {
        if !locationSwitch.isOn {
            locationManager.startUpdatingLocation()
            let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
            mapView.removeAnnotations(annotations)
            userLocationModeImage.tintColor = #colorLiteral(red: 0.4666666687, green: 0.8900527835, blue: 0.2666666806, alpha: 1)
            pinModeImage.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else {
            if pinLocation.latitude == 0.0 && pinLocation.longitude == 0.0 {
                pinLocation = mapView.centerCoordinate
            }
            pinModeImage.tintColor = #colorLiteral(red: 0.4666666687, green: 0.8900527835, blue: 0.2666666806, alpha: 1)
            userLocationModeImage.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            addAnnotation(location: CLLocationCoordinate2D(latitude: pinLocation.latitude, longitude: pinLocation.longitude))
        }
        
        mapView.showsUserLocation = !locationSwitch.isOn
    }
}

//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            panToLocation(location)
            userLocation = location
            mapWeather.locationDidChange(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Authorization changed")
    }
}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
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
        mapWeather.locationDidChange(lat: location.latitude, lon: location.longitude)
    }
    
   
}





