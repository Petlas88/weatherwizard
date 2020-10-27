//
//  Weathermanager.swift
//  WeatherWizard
//

import Foundation

struct WeatherManager {
    let weatherUrl = "https://api.met.no/weatherapi/locationforecast/2.0/compact.json?"
    
    func fetchWeather(lat: Double, lon: Double)  {
        
        let urlString = "\(weatherUrl)lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString:String)  {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    //Needed the self. notation in the past, seems to be working fine without it now (Swift 5, Xcode 12.1)
                    parseJSON(weatherData: safeData)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        
        
        do {
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print("Instant")
            print(decodedData.properties.timeseries[1].data.instant.details.air_temperature)
            print("******")
            print("Rain next 6h")
            
        
        } catch {
            print(error)
        }
        
    }
    
    
}
