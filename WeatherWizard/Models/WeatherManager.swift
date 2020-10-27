//
//  Weathermanager.swift
//  WeatherWizard
//
//  Created by Lasse Pettersen on 26/10/2020.
//

import Foundation

struct WeatherManager {
    let weatherUrl = "https://api.met.no/weatherapi/locationforecast/2.0/compact.json?"
    
    func fetchWeather(lat: Double, lon: Double)  {
        
//        lat=59.911166&lon=10.744810
        let urlString = "\(weatherUrl)lat=\(lat)&lon=\(lon)"
        print(urlString)
    }
    
    func performRequest(urlString:String)  {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
           let task = session.dataTask(with: url, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
            
            task.resume()
        }
    }
}
