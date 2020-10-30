//
//  MapWeather.swift
//  WeatherWizard
//
//  Created by Lasse Pettersen on 30/10/2020.
//

import UIKit
import MapKit

protocol MapWeatherDelegate {
    func didGetData()
}

class MapWeather: UIView {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latDegreesLabel: UILabel!
    @IBOutlet weak var lonDegreesLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var delegate: MapWeatherDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame:  frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        let viewFromXib = Bundle.main.loadNibNamed(K.mapWeatherName, owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        weatherIcon.image = UIImage(systemName: "cloud.fog" )
        
        addSubview(viewFromXib)
    }
    
}
