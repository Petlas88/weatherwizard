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
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    
    }


}


